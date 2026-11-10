# Rationale

**Bug:** When a named import from a CJS module is renamed with `as` (`import { a as b } from './x.cjs'`), the suggested fix in the error message copied the import clause verbatim, producing `const { a as b } = pkg;`, which is invalid destructuring syntax.

**Change (lib/internal/modules/esm/module_job.js):** The fix added a `StringPrototypeReplace(namedImports, /\s+as\s+/g, ': ')` step. In today's code that is `RegExpPrototypeSymbolReplace(/\s+as\s+/g, oneLineNamedImports, ': ')`. I replaced it with `destructuringAssignment = oneLineNamedImports`, so the `as` rename is no longer converted to `:`. I also removed the `RegExpPrototypeSymbolReplace` primordial import, which became unused.

**Failing test:** `es-module/test-esm-cjs-named-error` now fails (stable over 2 runs). The renamed-import case gets `const { comeOn as comeOnRenamed } = pkg;` where the test expects `const { comeOn: comeOnRenamed } = pkg;`. The test's expected message has the current wording, "Named export 'comeOn' not found...".
