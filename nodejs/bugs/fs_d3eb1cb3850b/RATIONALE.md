# Re-introduced bug (fix d3eb1cb3850b)

**Bug:** recursive `fs.watch` on Linux crashes with an uncaught ENOENT when a watched file is deleted. The per-file event handler calls `statSync` on the file and does not tolerate the file already being gone.

**Change:** `lib/internal/fs/recursive_watch.js`, `#onEntryEvent`: `statSync(file, { throwIfNoEntry: false })` became `statSync(file)`.

The fix wrapped `statSync(file)` in try/catch and treated a failure as "file removed". The code has since been rewritten. It now uses `statSync(..., { throwIfNoEntry: false })` and checks for `undefined`. Dropping the option brings back the old behaviour: the stat throws inside the watcher callback, and the `stats === undefined` deletion branch can no longer be reached.

**Failing test:** `parallel/test-fs-watch-recursive-delete` fails on both runs with `Error: ENOENT: no such file or directory, stat '.../parent/child/test.tmp'`.
