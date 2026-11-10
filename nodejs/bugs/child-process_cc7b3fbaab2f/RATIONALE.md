# Re-introduced bug (nodejs/node#27097)

When a stream (e.g. `p1.stdout`, `p3.stdin`) is passed as `stdio` to a child process, `ChildProcess.prototype.spawn` fully closes its underlying handle. The stream can then no longer be used at all, e.g. passed to another child process or read later by the parent.

## Hunks (lib/internal/child_process.js)
1. Fix hunk "stop readable side only" (`handle.reading=false; readStop(); _stdio.pause(); ...; _stdio[kIsUsedAsStdio]=true`) is reverted to the old `stream.handle.close()` plus emitting `'close'` on `_stdio` if it is an EventEmitter. This destroys the shared resource.
2. Fix hunk adding `const kIsUsedAsStdio = Symbol(...)` is removed, since it is now unused.
3. Fix hunk in `flushStdio` (skip streams with `kIsUsedAsStdio`) is reverted to the pre-fix check. The current code has no `readableListening` condition, so only the `kIsUsedAsStdio` term was dropped.

## Failing tests
Run twice with the same result:
- parallel/test-child-process-stdio-merge-stdouts-into-cat: not ok
- parallel/test-child-process-stdio-reuse-readable-stdio: not ok
- parallel/test-child-process-server-close: not ok

I did not capture the individual failure messages. test-child-process-pipe-dataflow still passes.
