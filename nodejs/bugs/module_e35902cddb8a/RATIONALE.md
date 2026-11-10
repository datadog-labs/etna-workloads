# Rationale

**Bug:** In `getFileProtocolModuleFormat` for `.ts` files with no `type` in package.json, a call from `defaultResolve` (no `source`) wrongly returned `module-typescript` instead of deferring. So a CommonJS-syntax `.ts` file loaded via `import()` from a `.mjs` was treated as ESM and failed with `require is not defined in ES module scope` (nodejs/node#54457).

**Change (lib/internal/modules/esm/get_format.js, one hunk)** corresponds to the fix's get_format.js hunk. It removes `if (!source) return null;` and the unconditional stringify/strip. Types are stripped only when `source` exists, and format detection runs on possibly-undefined source. The format falls back to `module-typescript` when detection yields nothing. The fix's helpers.js/translators.js hunks only moved `stringify`/`assertBufferSource`, which already live in helpers today, so they need no reversal.

**Failing test:** `es-module/test-typescript` fails ("not ok") on both runs, in the test "execute a JavaScript file importing a cjs TypeScript file". The message is `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal` with `ReferenceError: require is not defined in ES module scope, you can use import instead` in stderr.
