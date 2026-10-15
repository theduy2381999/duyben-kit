# Security

- Never hard-code secrets, tokens or passwords; read them from environment variables or a secret manager.
- Never print secrets to logs, not even while debugging.
- Validate all external input (requests, files, environment variables) before use.
- Use parameterized queries; never build SQL or shell commands by string concatenation.
- When adding a dependency, choose a widely used, actively maintained package.
