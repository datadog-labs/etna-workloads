Input: `import type from = require("./mod");` (an import-equals whose alias is named `type`) plus `export { type }`.
Clean: parsed as an import-equals declaration; compiles and emits `const type = require(...)`.
Injected: `type` is taken as a type-only modifier and `from` as the import name, so parsing fails with syntax errors.
