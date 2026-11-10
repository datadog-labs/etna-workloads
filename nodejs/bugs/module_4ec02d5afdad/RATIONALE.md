# Re-introduced bug: dynamic import from `--eval`

**Bug.** `import()` inside code run via `node --eval` (CommonJS script eval, and `--input-type=module` eval)
had no dynamic-import callback registered, so it threw `ERR_VM_DYNAMIC_IMPORT_CALLBACK_MISSING` instead of loading the module.

## Hunks
1. `lib/internal/process/execution.js` (`compileScript`): corresponds to the fix's `execution.js` hunk that added
   `importModuleDynamically` to the eval'd script. I removed the callback and pass `undefined`, so eval'd scripts have
   no dynamic import handler (as before the fix).
2. `lib/internal/modules/esm/loader.js` (`Loader.eval`, plus `kInternal` import): corresponds to the fix's `loader.js` hunk
   that registered `importModuleDynamically` for eval'd modules. The wrap is now built with `kInternal` (no host-defined
   options / callback) instead of `kUser`, so `import()` in eval'd ESM has no callback either.

## Failing test
`parallel/test-cli-eval` (stable over 2 runs):
`AssertionError [ERR_ASSERTION]: ifError got unwanted exception: Command failed: ... --eval "process.chdir('..');import('./test/fixtures/es-modules/mjs-file.mjs')"`
with stderr `TypeError [ERR_VM_DYNAMIC_IMPORT_CALLBACK_MISSING]: A dynamic import callback was not specified.`
(The test's cases use `--input-type module`, so hunk 2 is what triggers the failure; hunk 1 alone left it passing.)
