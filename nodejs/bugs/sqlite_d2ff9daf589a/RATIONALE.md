# Re-introduced bug: sqlite applyChangeset callbacks stored in process-wide statics

**Bug.** `DatabaseSync::ApplyChangeset` (here `Database::ApplyChangeset`) kept the user's `onConflict` and
`filter` callbacks in process-wide state, and SQLite's `xConflict`/`xFilter` trampolines read that state
(`pCtx` was unused). Callbacks are V8 handles bound to one isolate, so with Worker threads applying changesets
at once, one thread overwrites or clears the other's callbacks, or calls them from the wrong isolate. The
result is wrong conflict decisions or a crash.

**Change (src/node_sqlite.cc)**, one hunk per hunk of the fix:
1. Fix hunk "struct ConflictCallbackContext / static std::function globals": in the release the struct already
   exists, so I added a single `static ConflictCallbackContext shared_context;` back. This is the old
   shared static state.
2. Fix hunk changing `xConflict`/`xFilter` to read `pCtx`: both now use `&shared_context` and ignore `pCtx`.
3. Fix hunk `ConflictCallbackContext context;` local in ApplyChangeset (the old code reset the statics to
   nullptr at entry): it now resets `shared_context` and binds `context` as a reference to it, so the
   existing lambda assignments write into the shared state.
4. Fix hunk passing `&context` to `sqlite3changeset_apply`: reverted to passing `nullptr`.

**Test results.** I could not get a reliable failure here.
- Both oracle tests report `not ok` (exit -11/SIGABRT) under `tools/test.py`. They do the same on the clean
  tree. The cause is an environment problem unrelated to this change: glibc aborts with
  `munmap_chunk(): invalid pointer` inside OpenSSL cleanup at process exit, whenever node runs with
  `--test-reporter=./test/common/test-error-reporter.js`. A trivial node:test file crashes the same way.
- Run directly, all 43 session tests pass, including "concurrent applyChangeset with workers". That test is a
  race, so the bug showed up only when the two workers' applyChangeset calls overlapped, and I did not see
  that in the runs I made.
- So I could not confirm that the failure comes from the re-introduced bug. The `not ok` results are the
  environment crash, which also occurs without my change.
