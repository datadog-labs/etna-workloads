a.ts exports a function `A` via `export type { A }`; b.ts merges a namespace `A` with the type-only import and re-exports it; c.ts uses `A` as a value.
Clean build keeps `const b_1 = require("./b");` in the emitted c.js. Injected build wrongly elides it (the import is not marked referenced).
