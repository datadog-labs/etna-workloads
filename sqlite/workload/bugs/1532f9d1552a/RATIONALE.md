# Rationale

Hunk changed: `ext/fts5/fts5_main.c`, `fts5CheckTransactionState()`, case FTS5_SYNC.
The fix relaxed `assert( p->ts.eState==1 )` to `assert( p->ts.eState==1 || p->ts.eState==2 )`.
I restored the original, stricter assert. The code is otherwise identical to the pre-fix code.

The memdb xLock/xUnlock hunks of the fix are not reverted. They are a refactor,
and the tests only need the fts5 assert to reproduce the bug.

Oracle failure: fts5misc-14.3 (the second failed COMMIT, which calls xSync again
with eState already 2) aborts with
`Assertion 'p->ts.eState==1' failed` in fts5CheckTransactionState. The run dies there,
so 14.4 and later cases do not run. This needs a SQLITE_DEBUG build, which check.sh uses.
