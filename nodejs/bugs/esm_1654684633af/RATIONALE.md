# Re-introduced bug
Watch-mode dependency reporting (`watch:import`/`watch:require` IPC message) in
`ModuleLoader.#getOrCreateModuleJobAfterResolve` (lib/internal/modules/esm/loader.js) happened only after
`loadAndTranslate*` ran. If parsing/translation throws (e.g. SyntaxError) the file is never reported,
so the watcher doesn't track it and never restarts after the user fixes the file.

## Change
Single hunk: moved the `WATCH_REPORT_DEPENDENCIES` reporting block (including the worker relay block that
exists in today's code) from the top of the function (after `const { url, format }`) to just before
`ModuleJobCtor` selection, after loading/translation. This mirrors the fix hunk pair (add early / remove late) in reverse.

## Failing test
sequential/test-watch-mode-restart-esm-loading-error: "not ok" (stable over 2 runs),
`Error: Timed out waiting for restart`.
