---
description: Install duyben-kit (rules, CLAUDE.md, settings, plugins) into the current project
argument-hint: "[profile: base | web | python]"
allowed-tools: Bash(git rev-parse:*), Bash(ls:*), Bash(curl -fsSL https://raw.githubusercontent.com/theduy2381999/duyben-kit/main/install.sh), Bash(bash -s --:*)
---

## Context

- Git root: !`git rev-parse --show-toplevel 2>/dev/null || echo "not a git repository"`
- Files in the current directory: !`ls -A`

## Task

Install duyben-kit into this project.

1. **Project root**: use the git root above; if this is not a git repository, use the current directory.
2. **Profile**:
   - If the user passed a profile, use it: `$ARGUMENTS`
   - Otherwise detect it from the project files:
     - `package.json` or `tsconfig.json` -> `web`
     - `pyproject.toml`, `requirements.txt` or `setup.py` -> `python`
     - anything else -> `base`
   - Tell the user which profile you picked and why, in one line.
3. **Install** by running exactly this command (replace the placeholders):

   ```bash
   curl -fsSL https://raw.githubusercontent.com/theduy2381999/duyben-kit/main/install.sh | bash -s -- <profile> <project-root>
   ```

   If it fails with an unknown profile, show the available profiles from the output and ask the user to choose.
4. **Report** what the script installed (rules, plugins, CLAUDE.md, settings), using its output.
5. **Next steps**, tell the user to:
   - Exit and restart `claude` so the new CLAUDE.md, rules and settings are loaded.
   - Accept the prompt to install the duyben-kit plugins after restarting.
   - Fill in the placeholders in `CLAUDE.md` if it was created from the template; offer to do this now by analyzing the project.
