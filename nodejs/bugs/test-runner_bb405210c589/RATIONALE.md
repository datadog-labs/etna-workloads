# Re-introduced bug: TypeScript module mocking unsupported

`mock.module()` in the test runner did not work for TypeScript files (`--experimental-strip-types`). When the caller was a `.ts` file its stack-frame filename is already a `file://` URL, but it was passed through `pathToFileURL`, which produced a bogus URL. The TypeScript formats were also not accepted as mockable, and the mock source was not generated as ESM for `module-typescript`.

## Hunks
- `lib/internal/test_runner/mock/mock.js` `kSupportedFormats`: removed `commonjs-typescript` and `module-typescript` (fix hunk 3a).
- `lib/internal/test_runner/mock/mock.js` caller: always `pathToFileURL(filename).href`, dropping the `file://` check (fix hunk 3b). This is what causes the observed failure.
- `lib/internal/test_runner/mock/loader.js`: `useESM = format === 'module'` only (fix hunk 2).
- `lib/internal/modules/esm/translators.js`: `assertBufferSource(source, false, 'load')` in the `commonjs-typescript` and `module-typescript` translators (fix hunk 1). Today's code passes `true`; it is reverted to the pre-fix `false`.

## Failing test
`es-module/test-typescript`: "execute a TypeScript test mocking module" fails on both runs, with:
`AssertionError [ERR_ASSERTION]: The input did not match the regular expression /Hello, TypeScript-Module!/` and
`ERR_MODULE_NOT_FOUND: Cannot find module '.../file:/.../test/fixtures/typescript/ts/module-logger.ts'`.
