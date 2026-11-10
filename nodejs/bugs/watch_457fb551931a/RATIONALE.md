# Re-introduced bug: `--env-file-if-exists` / `fs.watch({throwIfNoEntry:false})` ENOENT crash

**Bug.** `fs.watch` had no way to tolerate a missing path in the native (non-recursive) watcher, and watch mode
treated `--env-file-if-exists` files like required `--env-file` files, so a missing optional file could make
the watcher throw `ENOENT: no such file or directory, watch`.

**Hunks (the release's code moved on: the fix's `files_watcher.js`/`recursive_watch.js` parts are already
reshaped, so only the parts still meaningful were reverted).**
1. `lib/internal/fs/watchers.js` – reverts the fix's `watchers.js` hunks: removed the `UV_ENOENT` import, the
   `throwIfNoEntry = true` parameter of `kFSWatchStart`, and the `if (!throwIfNoEntry && err === UV_ENOENT) return;`
   early return. `fs.watch(missing, {throwIfNoEntry:false})` now throws ENOENT again.
2. `lib/internal/main/watch_mode.js` – reverts the fix's hunks: `kEnvFiles` again merges `--env-file` and
   `--env-file-if-exists`, and the separate `kOptionalEnvFiles` loop passing `{ allowMissing: true }` is gone.
   (`files_watcher.js` still accepts `allowMissing`, now unused.)

**Failing test.** `parallel/test-fs-watch-enoent` (stable over 2 runs):
`not ok 1 parallel/test-fs-watch-enoent` — `Error: ENOENT: no such file or directory, watch '.../non-existent'`
(from the `throwIfNoEntry: false` case). `sequential/test-watch-mode` still passes, since on Linux the parent
directory is watched and exists in that test.
