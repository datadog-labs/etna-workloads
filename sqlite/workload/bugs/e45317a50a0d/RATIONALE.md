# Rationale

## Hunk changed
`ext/fts5/fts5_index.c`, `fts5FlushOneHash()` (secure-delete branch, the `if( bTermWritten==0 )` before `fts5WriteAppendTerm`).

Reverses the fix's only implementation hunk: the fix changed `if( bTermWritten==0 )` to `if( p->rc==SQLITE_OK && bTermWritten==0 )`. The code has the same shape in 3.54.1, so I removed the `p->rc==SQLITE_OK &&` guard. After an OOM inside `fts5FlushSecureDelete()`, `p->rc` is nonzero, and `fts5WriteAppendTerm()` is now called with an error already set. That can lose or overwrite the error code. The nearby `assert( p->rc!=SQLITE_OK || ... )` was already tolerant of this, so I left it alone.

The similar guard in `fts5IndexMergeLevel()` (line ~4876) is not part of the fix and is untouched.

## Oracle failures
`fts5securefault.test` aborts in the OOM fault-injection loop (case 1.1-oom-persistent.248 and later) with `Assertion 'p->rc==SQLITE_OK' failed` in `fts5WriteAppendTerm`. Cases up to .247 pass. Because the test process aborts, the later cases, including 6.1 added by the fix, never run.
