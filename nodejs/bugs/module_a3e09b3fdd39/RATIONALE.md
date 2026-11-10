# Re-introduced bug: `--import` modules run concurrently

**Bug.** Modules given via `--import` were imported in parallel (`SafePromiseAllReturnVoid`) instead of one after another. A module with top-level await therefore did not block later `--import` modules, so output/side effects interleaved out of order.

**Change (lib/internal/modules/run_main.js, `asyncRunEntryPointWithESMLoader`).** The code the fix touched (`lib/internal/process/esm_loader.js`) no longer exists; the equivalent loop now lives here.
- Hunk 1 corresponds to the fix's replacement of `SafePromiseAllReturnVoid(...)` with a sequential `for ... await` loop. I restored the `SafePromiseAllReturnVoid(userImports, specifier => cascadedLoader.import(...))` call, which starts all imports at once.
- Hunk 2 adds `SafePromiseAllReturnVoid` to the `primordials` destructuring, matching the fix's removal of that import.

**Failing test.** `es-module/test-esm-import-flag`, case "should import files sequentially" (the case that checks `--import` files from the env run before ones from the CLI also exercises this). Failure: `actual: '3\n1\n2\n'`, `expected: /^1\r?\n2\r?\n3\r?\n$/`. The result was the same on two runs.
