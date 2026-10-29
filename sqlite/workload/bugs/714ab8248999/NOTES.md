repro.sql runs the join-35.1 query: 37 nested scalar subqueries, each with a RIGHT JOIN, inside an outer query with 63 chained RIGHT JOINs. That pushes RIGHT JOIN subroutine nesting past 100.
Clean shell: "Parse error ... too many RIGHT JOINs", exit 1.
Buggy shell: assertion failure `pParse->withinRJSubrtn < 100` in sqlite3WhereRightJoinLoop, abort (exit -6).
join-36.x fail only because the test run aborts at join-35.1.
