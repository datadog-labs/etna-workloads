b.ts contains `import type from from './a';` (default import named `type`).
Clean parses it as a default import: no diagnostics, b.js has no stray statement.
Injected treats `type` as a modifier and fails to parse `from`, giving errors and a stray `'./a';` statement in the emitted JS.
