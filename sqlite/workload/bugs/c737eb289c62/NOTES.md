`repro.sql` runs two FTS5 queries whose column filter excludes every column (`-{c0} : x`), once under NOT and once under AND (cases 6.6 and 6.7 of fts5colset.test).
Clean shell: no rows, exit 0. Buggy shell: assertion failure `fts5ExprNodeTest_NOT: Assertion 'rc!=SQLITE_OK || cmp<=0'` (abort).
The injection removes `bEof = 1` from `fts5IterSetOutputs_ZeroColset`, so the empty iterator never reports EOF.
