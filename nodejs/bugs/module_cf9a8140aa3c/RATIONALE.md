# Re-introduced bug: extensionless require of .ts/.cts under --experimental-strip-types

**Bug.** With type stripping enabled, `require("./foo")` resolved to `foo.ts` or `foo.cts`. This is extensionless require of TypeScript files, and it should fail with "Cannot find module".

**Why not a plain reversal.** The fix's `getDefaultExtensions` filter no longer exists, and `.ts`/`.cts` are no longer registered in `Module._extensions` (they're handled inside the `.js` handler). The old behaviour is therefore rebuilt differently.

**Change** (`lib/internal/modules/cjs/loader.js`).
- Added `getDefaultExtensions()`. It returns `ObjectKeys(Module._extensions)` and, when `--strip-types` is on, appends `.ts` and `.cts`. This corresponds to the fix's `getDefaultExtensions` hunk: the extension list used for extensionless lookup once again includes `.ts` and `.cts`, which the fix excluded.
- The two `exts = ObjectKeys(Module._extensions)` call sites in `Module._findPath` (file lookup and directory index lookup) now call `getDefaultExtensions()`. This corresponds to the fix's use of that function in the resolution paths.

**Failing test.** `es-module/test-typescript-commonjs` fails. The tests "eval require a .ts/.cts file with implicit extension fails" and "require a .ts file with implicit extension fails" now see the file load successfully, with exit code 0 and no "Cannot find module" error.
