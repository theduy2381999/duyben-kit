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
│   └── python/               # Python
├── rules/                    # Things Claude ALWAYS FOLLOWS, copied into .claude/rules/kit/
│   ├── common/
│   ├── typescript/
│   └── python/
├── templates/                # Default CLAUDE.md and settings.json for new projects
├── profiles/                 # Preset bundles of rules and plugins per project type
└── install.sh                # Installs the kit into a project
```

## Principles

1. **The kit only writes to its own folder.** `.claude/rules/kit/` is overwritten on every install; project-specific rules live outside it.
2. **Never overwrite project files.** `CLAUDE.md` is created only if missing; `settings.json` is merged.
3. **Small pieces, composed.** Each plugin or rule group does one thing; a profile is just a list of what to combine.
