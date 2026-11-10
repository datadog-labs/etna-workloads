# Re-introduced bug: strip-types / detect-module interaction

**Bug.** With `--experimental-strip-types`, a `.ts` file (or eval input) with no package `type` goes through module-format detection on stripped source. When the source is missing/empty, detection yields null and the format was wrongly forced to `commonjs-typescript`, instead of deferring; and `shouldUseESMLoader` didn't route an empty `mainPath` (eval/stdin) to CJS. Result: ESM-syntax `.ts` files and empty `.ts` files misbehave.

**Hunks**
1. `lib/internal/modules/esm/get_format.js` (fix hunk: `commonjs-typescript` fallback → `module-typescript`): the current code has an early `if (!source) return null`. I removed it, strip only when source exists, and restored `detectedFormat ? ... : 'commonjs-typescript'`, the pre-fix fallback.
2. `lib/internal/modules/run_main.js` (fix hunk `!mainPath || ...cts`): reverted to `mainPath && endsWith('.cts')`.
(The helpers.js `tsParse` hunk has no counterpart: that function no longer exists in this release.)

**Failing tests** (confirmed on two runs): `es-module/test-typescript` and `es-module/test-typescript-module` report `not ok`. (Subtests include module-syntax `.ts` and import-related cases; see TAP output.)
