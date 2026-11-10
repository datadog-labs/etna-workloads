# Re-introduced bug: writeHeapSnapshot does not throw on open/close failure

**Bug.** `v8.writeHeapSnapshot(path)` silently returned (undefined, no exception) when the
output file could not be opened (e.g. EACCES on a read-only file), and a failing close was
also swallowed into a silent failure.

**Changes (src/heap_utils.cc, `heap::WriteSnapshot`)**
1. Removed `env->ThrowUVException(err, "open", ...)` on open failure. Corresponds to the fix's
   `env->ThrowErrnoException(errno, "open")` hunk; without it the function returns Nothing
   with no pending exception, as before the fix.
2. Removed `env->ThrowUVException(err, "close", ...)` on close failure. Corresponds to the fix's
   `fclose == EOF` error-handling hunk (the old code ignored close errors). The signature
   refactor (Isolate* -> Environment*) is already in the release, so no hunk is needed.

**Failing test.** `sequential/test-heapdump` fails: the `assert.throws(() => writeHeapSnapshot('ro'))`
check reports "Missing expected exception", since no EACCES/open error is thrown.
