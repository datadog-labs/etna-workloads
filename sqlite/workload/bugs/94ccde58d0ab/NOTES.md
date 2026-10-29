repro.sql is select1-6.22: a compound SELECT (`b ... UNION SELECT '3' AS x ORDER BY b LIMIT 2`) used inside an IN subquery.

The ORDER BY term `b` has to be matched to a result column by comparing it with the result-set expressions. The injection removes that expression match in resolve.c.

- Clean shell: prints `a` and `b`, exit status 0.
- Buggy shell: `Parse error near line 6: 1st ORDER BY term does not match any column in the result set`, exit status 1.
