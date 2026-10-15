---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript

- Do not use `any`; use `unknown` with a type guard when the type is not known.
- Use named exports, not default exports.
- Prefer `type` for unions and data shapes; `interface` for extensible object contracts.
- Do not use the non-null assertion (`!`) unless the value is proven to exist.
- Use `async/await` instead of `.then()` chains; always handle Promise rejections.
- React components are function components with explicitly typed props.
