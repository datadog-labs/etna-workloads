`repro.sql` is the window1-69.0 test case. It runs a subquery with a misuse-of-aggregate error (`SUM()` inside a window ORDER BY), compared against an indexed column.

- Clean shell: `Parse error near line 3: misuse of aggregate: SUM()`, exit 1.
- Buggy shell: `sqlite3TableColumnAffinity: Assertion 0 failed`, abort, exit 134.

The injected bug removes the `pParse->nErr==0` check in `codeAllEqualityTerms`. Affinity code then runs on a tree left inconsistent by the syntax error.
