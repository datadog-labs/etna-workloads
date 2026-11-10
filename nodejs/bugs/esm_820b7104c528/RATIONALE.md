# Re-introduced bug: erroneous re-initialization of the ESM loader (upstream 820b7104c5)

**Bug.** `Module.runMain()` re-runs the ESM entry-point setup. Before the fix, that setup
re-initialized ESM and registered the `--experimental-loader` hooks again, so each hook ran
twice (duplicate custom loaders on the public loader). The fix added an `isESMInitialized`
guard in `initializeLoader()`.

**Today's code.** `lib/internal/process/esm_loader.js` and `initializeLoader()` no longer exist.
Custom loaders are registered on a loader-hook worker, and the entry-point setup is
`asyncRunEntryPointWithESMLoader` in `lib/internal/modules/run_main.js`. That function runs
on every `runMain()` call and is where the guard belongs.

**Change (one hunk, `lib/internal/modules/run_main.js`).** This corresponds to the fix's
`if (isESMInitialized) return;` guard and `isESMInitialized = true;` flag, removed or inverted.
I added a module-level `hasInitializedEntryPoint` flag. On the second and later calls to
`asyncRunEntryPointWithESMLoader` (e.g. via `runMain()`), the code calls
`cascadedLoader.register()` again for every `--experimental-loader`. This is the pre-fix
behaviour of adding the custom loaders again on each re-run. Each hook is then chained twice
in the worker.

**Failing test.** `es-module/test-esm-initialization` fails on both runs:
`AssertionError: Expected values to be strictly equal: 7 !== 5` (the resolve-passthru hook
ran 7 times instead of 5).

**Not attempted.** An earlier attempt that re-created the whole cascaded loader made `runMain`
loop forever. I discarded it because it was not faithful to the fix.
