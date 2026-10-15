#!/usr/bin/env bash
# Install duyben-kit rules, CLAUDE.md and settings into a project.
#
# Usage:  install.sh [profile] [project-dir]
#   profile defaults to "base"; project-dir defaults to the current directory
#
# Optional environment variables:
#   KIT_GH       GitHub owner/repo, used to register the plugin marketplace
#   KIT_GIT_URL  URL to clone the kit from (defaults to https; use SSH for a private repo)
#   KIT_REF      branch or tag to install, e.g. v1.2.0 (default: main)
#   KIT_SOURCE   use an existing local kit checkout instead of cloning (for testing)
set -euo pipefail

KIT_GH="${KIT_GH:-theduy2381999/duyben-kit}"
KIT_GIT_URL="${KIT_GIT_URL:-https://github.com/$KIT_GH.git}"
KIT_REF="${KIT_REF:-main}"
KIT_NAME="duyben-kit"   # must match "name" in .claude-plugin/marketplace.json
PROFILE="${1:-base}"
TARGET="${2:-.}"

die() { echo "Error: $*" >&2; exit 1; }

command -v jq  >/dev/null || die "jq is required (sudo apt install jq / brew install jq)"
command -v git >/dev/null || die "git is required"
[[ -d "$TARGET" ]] || die "Project directory not found: $TARGET"

# 0. Fetch the kit
if [[ -n "${KIT_SOURCE:-}" ]]; then
  KIT="$(cd "$KIT_SOURCE" && pwd)"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  git clone --quiet --depth 1 --branch "$KIT_REF" "$KIT_GIT_URL" "$tmp/kit" \
    || die "Could not clone $KIT_GIT_URL (ref: $KIT_REF)"
  KIT="$tmp/kit"
fi

profile_file="$KIT/profiles/$PROFILE.conf"
if [[ ! -f "$profile_file" ]]; then
  echo "Available profiles:" >&2
  ls "$KIT/profiles" | sed 's/\.conf$//; s/^/  - /' >&2
  die "Unknown profile '$PROFILE'"
fi
RULES=(); PLUGINS=()
# shellcheck source=/dev/null
source "$profile_file"

# 1. Rules: .claude/rules/kit/ is owned by the kit and replaced on every install.
#    Project-specific rules live outside kit/ and are left untouched.
rules_dir="$TARGET/.claude/rules/kit"
rm -rf "$rules_dir"
mkdir -p "$rules_dir"
for r in "${RULES[@]}"; do
  [[ -d "$KIT/rules/$r" ]] || die "Profile '$PROFILE' references rules/$r, which does not exist"
  cp -r "$KIT/rules/$r" "$rules_dir/$r"
  rm -f "$rules_dir/$r/.gitkeep"
done
version="$(git -C "$KIT" rev-parse --short HEAD 2>/dev/null || echo local)"
printf 'profile=%s\nversion=%s\n' "$PROFILE" "$version" > "$rules_dir/.kit-info"

# 2. CLAUDE.md: only created when the project does not have one yet
if [[ -f "$TARGET/CLAUDE.md" ]]; then
  claude_md_msg="kept (already exists)"
else
  cp "$KIT/templates/CLAUDE.md" "$TARGET/CLAUDE.md"
  claude_md_msg="created from template"
fi

# 3. settings.json: merge default settings, the marketplace and the plugins.
#    Existing project values win; permission lists are combined.
settings="$TARGET/.claude/settings.json"
[[ -f "$settings" ]] || echo '{}' > "$settings"
jq -e . "$settings" >/dev/null 2>&1 || die "$settings is not valid JSON"

plugins_json="$(
  for p in "${PLUGINS[@]}"; do
    grep -q "\"name\": *\"$p\"" "$KIT/.claude-plugin/marketplace.json" \
      || die "Plugin '$p' is not declared in marketplace.json"
    printf '%s\n' "$p"
  done | jq -R --arg kit "$KIT_NAME" '{(. + "@" + $kit): true}' | jq -s 'add // {}'
)"

jq --slurpfile base "$KIT/templates/settings.json" \
   --argjson plugins "$plugins_json" \
   --arg repo "$KIT_GH" --arg kit "$KIT_NAME" '
  . as $proj
  | ($base[0] * $proj)
  | .permissions.allow = ((($base[0].permissions.allow // []) + ($proj.permissions.allow // [])) | unique)
  | .permissions.deny  = ((($base[0].permissions.deny  // []) + ($proj.permissions.deny  // [])) | unique)
  | .extraKnownMarketplaces[$kit] = {source: {source: "github", repo: $repo}}
  | .enabledPlugins = ((.enabledPlugins // {}) + $plugins)
' "$settings" > "$settings.tmp" && mv "$settings.tmp" "$settings"

echo "Installed $KIT_NAME (profile: $PROFILE, version: $version) into $(cd "$TARGET" && pwd)"
echo "  - Rules:      .claude/rules/kit/ (${RULES[*]})"
echo "  - Plugins:    ${PLUGINS[*]}"
echo "  - CLAUDE.md:  $claude_md_msg"
echo "  - Settings:   .claude/settings.json"
echo
echo "Next: open 'claude' in the project, trust the folder and accept the plugin install prompt."
