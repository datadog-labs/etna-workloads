# Rationale

Hunk reversed: `ext/fts5/fts5_index.c`, `fts5TestUtf8()`. The fix changed `assert( n>0 )` to `assert_nc( n>0 )`. I changed it back to plain `assert( n>0 )` (the line is still present in 3.54.1, so the reversal is direct).

With a corrupt fts5 record the term can have length 0, so the plain assert fires instead of the corruption being reported.

Failing oracle case: `fts5corrupt3-68.1`. It aborts with `fts5TestUtf8: Assertion 'n>0' failed`. The expected result is `{1 {database disk image is malformed}}`.
