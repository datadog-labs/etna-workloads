Language-service script: c.ts imports `b`, which is re-exported via `export type * as b` (type-only declaration) under verbatimModuleSyntax.
This yields the "resolves to a type-only declaration and must be imported using a type-only import" error; the script requests code fixes for it.
Clean: offers "Use import type" fix (`import type { b } ...`). Injected: no fixes offered (empty list).
