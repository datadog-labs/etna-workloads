# Rationale

**Bug:** `lib/internal/main/watch_mode.js` strips watch flags from the child's args. It only recognised the exact `--watch-path` token (plus its following value), so `--watch-path=dir` was passed on to the child. Also, with `--watch-path` the child was spawned with default (piped) stdio instead of `inherit`, so the child's stderr/stdout were not forwarded.

## Hunks
1. Arg filtering (fix hunk 1: `StringPrototypeStartsWith(arg,'--watch-path')` and prev-arg check): the current code's `startsWith('--watch-path')` branch, which handles the `=` form, is replaced with `arg === '--watch-path'` (skip it and the next arg). `--watch-path=x` is no longer stripped and leaks into the child's args.
2. Spawn stdio (fix hunk 2): `'inherit'` -> `undefined` when not filtering modules, so stdio is piped rather than inherited.

## Failing tests
`sequential/test-watch-mode` fails (`not ok 1`) on repeated runs: assertion errors in the watch-path cases (stderr no longer matches/forwarded, e.g. "Expected values to be strictly deep-equal", falsy `assert` on `Error: Cannot find module` matches) and "Timed out waiting for restart".
