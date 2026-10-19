# duyben-kit

A central home for reusable **skills, rules, commands, agents, hooks and configuration** for projects built with [Claude Code](https://claude.com/claude-code).

## Structure

```
duyben-kit/
├── .claude-plugin/
│   └── marketplace.json      # Plugin catalog (this repo is a Plugin Marketplace)
├── plugins/                  # Things Claude CALLS ON DEMAND: skills, commands, agents, hooks
│   ├── core/                 # Shared by every project
│   ├── frontend/             # React / TypeScript
│   ├── python/               # Python
│   └── docs-digest/          # Docs link → beginner-friendly HTML digest
├── rules/                    # Things Claude ALWAYS FOLLOWS, copied into .claude/rules/duyben-kit/
│   ├── common/
│   ├── typescript/
│   └── python/
├── templates/                # Default CLAUDE.md and settings.json for new projects
├── profiles/                 # Preset bundles of rules and plugins per project type
└── install.sh                # Installs the kit into a project
```

## Usage

### Install into a project

Requires `git` and `jq`. Keep a checkout of the kit somewhere, then run the script from the project root.
The script always clones a fresh copy of the requested `KIT_REF`, so the checkout only provides the script itself:

```bash
git clone git@github.com:theduy2381999/duyben-kit.git ~/duyben-kit
cd my-project
KIT_GIT_URL=git@github.com:theduy2381999/duyben-kit.git ~/duyben-kit/install.sh web
```

Arguments: `install.sh [profile] [project-dir]`. Profiles live in `profiles/` (`base`, `web`, `python`).

| Variable      | Purpose                                   | Default                                  |
|---------------|-------------------------------------------|------------------------------------------|
| `KIT_GIT_URL` | Where to clone the kit from (SSH for a private repo) | `https://github.com/theduy2381999/duyben-kit.git` |
| `KIT_REF`     | Branch or tag to install                  | `main`                                   |
| `KIT_SOURCE`  | Use a local checkout instead of cloning   | unset                                    |

Then open `claude` in the project, trust the folder and accept the plugin install prompt. Commit `.claude/` and `CLAUDE.md` so the whole team shares the setup.

### Install from inside Claude Code

Install the `core` plugin once at user scope (see below), then in any project:

```
/core:duyben-kit          # auto-detects the profile from project files
/core:duyben-kit python   # or pick one explicitly
```

Restart `claude` afterwards so the new rules and settings are loaded.

### Install plugins only (user scope)

Inside Claude Code:

```
/plugin marketplace add theduy2381999/duyben-kit
/plugin install core@duyben-kit
```

### Update

| What                 | How                                                    |
|----------------------|--------------------------------------------------------|
| Rules and settings   | Re-run `install.sh` (pin a version with `KIT_REF=v1.1.0`) |
| Plugins              | `/plugin marketplace update duyben-kit` in Claude Code |
| Installed version    | `cat .claude/rules/duyben-kit/.kit-info`                      |

## Contributing

- New plugin: add `plugins/<name>/.claude-plugin/plugin.json` and register it in `.claude-plugin/marketplace.json`.
- New rule group: add `rules/<name>/*.md` (use `paths:` frontmatter to scope it to file types).
- New profile: add `profiles/<name>.conf` with `RULES=(...)` and `PLUGINS=(...)`.
- Bump `version` in a plugin's `plugin.json` whenever it changes, then tag a release.
- Validate before pushing: `claude plugin validate .` and `claude plugin validate plugins/<name>`.

## Principles

1. **The kit only writes to its own folder.** `.claude/rules/duyben-kit/` is overwritten on every install; project-specific rules live outside it.
2. **Never overwrite project files.** `CLAUDE.md` is created only if missing; `settings.json` is merged.
3. **Small pieces, composed.** Each plugin or rule group does one thing; a profile is just a list of what to combine.
