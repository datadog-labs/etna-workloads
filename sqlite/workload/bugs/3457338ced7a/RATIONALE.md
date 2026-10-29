# Rationale

Fix hunk: in `sqlite3StrAccumAppend()`, `assert( z!=0 )` was relaxed to
`assert( z!=0 || N==0 )`, since `printf('%n',0)` appends zero bytes from a NULL pointer.

In 3.54.1, `sqlite3StrAccumAppend` became `sqlite3_str_append` (public, keeps the
relaxed assert) and `sqlite3StrAppend64` (static, used by the printf core in
`sqlite3_str_vappendf`). The printf core path for `%n` goes through
`sqlite3StrAppend64`, so I restored the faulty `assert( z!=0 );` there (src/printf.c,
`sqlite3StrAppend64`). Same defect: an assert that wrongly rejects (NULL, 0) appends.

Oracle failures: printf2-1.12 (`SELECT printf('%n',0)`) aborts with
`sqlite3StrAppend64: Assertion 'z!=0' failed`; the run crashes, so later cases
(1.13 onward) also report as failing. Requires an assert-enabled build (testfixture).
