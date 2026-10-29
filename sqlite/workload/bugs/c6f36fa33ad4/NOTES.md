`repro.sql` is the test case orderby1-10.0 from the fix. It does an ORDER BY with LIMIT over a table that has an index on `b`, and the query uses the deferred-row-load optimization.

- Clean shell: returns `2|1|^`, `4|3|^`, `4|4|^`, `7|5|^`.
- Buggy shell: aborts with `Assertion 'memIsValid(pRec)' failed` (exit 134). The injection removes `regOrig = 0`, so the sorter reads result registers that haven't been computed yet.
