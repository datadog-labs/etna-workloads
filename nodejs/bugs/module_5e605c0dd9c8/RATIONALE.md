# Re-introduced bug: builtin reexport tracing

**Bug.** When an ESM file imports a CJS module that re-exports a builtin (`module.exports = require('assert')`),
the CJS export preparser recursed into the resolved reexport even when it was a builtin id (e.g. `assert`),
trying to read it as a file path. This made `import './dep1.js'` / `import { assert } from './dep2.js'` fail.

**Change** (lib/internal/modules/esm/translators.js, `cjsPreparseModuleExports`): the reexport recursion condition
was `format === 'commonjs' || (!BuiltinModule.normalizeRequirableId(resolved) && findLongestRegisteredExtension(resolved) === '.js')`;
it is now `format === 'commonjs' || findLongestRegisteredExtension(resolved) === '.js'`.
This corresponds to the fix's single hunk, which added `isAbsolute(resolved)` to the guard (today's equivalent
guard is the builtin check). Dropping it restores the old behaviour of recursing into non-file (builtin) specifiers.

**Failing test.** `es-module/test-esm-cjs-builtins`: "not ok", `AssertionError: 1 !== 0` (child exit code 1 instead of 0). Failure stable across runs.
