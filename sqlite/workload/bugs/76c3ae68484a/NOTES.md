`repro.sql` builds a detail=none fts5 table and runs `snippet()` on the query `x OR ""`. The empty phrase has 0 tokens.

Clean shell: prints `[x a a a a a...`.
Buggy shell: aborts on the assertion `nTerm==1` in `sqlite3Fts5ExprClearPoslists` (exit status -6). The fix relaxed that assertion to `nTerm<=1`.
