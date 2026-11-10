# Re-introduced bug: `--watch=true` causes infinite restart loop

**Bug.** The watch-mode parent process re-spawns the child with `process.execArgv` minus watch flags. If `--watch=true` is not stripped, the child also starts in watch mode, spawning its own watcher, which loops forever.

**Hunk (lib/internal/main/watch_mode.js).** The fix added `!StringPrototypeStartsWith(arg, '--watch=')` to the execArgv filter. In today's code the filter is a loop, `argsWithoutWatchOptions`. I removed its `if (StringPrototypeStartsWith(arg, '--watch=')) { continue; }` branch. `--watch=...` is now passed through to the child, as it was before the fix. Bare `--watch` is still stripped.

**Failing tests.** `sequential/test-watch-mode` reports `not ok` on 3 of 3 runs, with `AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal`. I did not capture the full output, so the exact failing subtest is not recorded here.
