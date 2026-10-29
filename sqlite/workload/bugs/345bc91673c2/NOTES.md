repro.sql runs the with5-310 query: a recursive CTE with ORDER BY id, selected with an outer ORDER BY ii.
The buggy build wrongly treats the CTE's ORDER BY as the order rows are emitted, so it skips the outer sort.
Clean shell prints 1,2,3. Buggy shell prints 1,3,2.
