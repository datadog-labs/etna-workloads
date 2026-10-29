repro.sql creates a temp zipfile vtab, inserts entries test1 and test2, then runs
`UPDATE OR REPLACE zip SET name='test2' WHERE name='test1'` and selects the names.
Clean: `test2`. Buggy: `test1` and `test2` (the replaced row isn't removed correctly; the old
entry is left in the list). Exit status is 0 on both; only the output differs.
