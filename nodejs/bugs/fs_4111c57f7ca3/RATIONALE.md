# Re-introduced bug: fs.stat/lstat/fstat throw when `options` is explicitly `undefined`

Upstream fix 4111c57 added `options = { bigint: false }` defaults to `fs.stat`, `fs.lstat` and `fs.fstat`, so `fs.stat(path, undefined, cb)` no longer throws. Without the default, an explicit `undefined` options argument reaches `options.signal`/`options.bigint` and raises a TypeError.

## Change (lib/fs.js, 3 hunks, one per function)
In `fstat`, `lstat` and `stat` I removed the default parameter value for `options`. This corresponds to the three signature hunks of the fix.
The current code also has a fallback branch (`options === null || typeof options !== 'object'` -> `kEmptyObject`) and, in `lstat`/`stat`, a `getOptions(...)` branch. Both would silently handle `undefined`, so I removed them too. That restores the pre-fix body, which only had the `typeof options === 'function'` check.

## Failing test
`parallel/test-fs-stat` fails (not ok) on both runs: `TypeError: Cannot read properties of undefined (reading 'signal')`, from `fs.stat(__filename, undefined, cb)`.
