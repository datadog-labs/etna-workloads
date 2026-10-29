Reproducer (`repro.sql`): creates t1, t2, t2x and runs the query from tkt-7a31705a7e6-1.1,
which uses `x.b=t2x.b` inside a subquery-aliased join.

Clean shell: the query succeeds and returns no rows (exit 0).
Buggy shell: `Parse error near line 4: ambiguous column name: main.t2x.b` (exit 1).
The buggy name matcher treats table name `t2` as matching `t2x` because it only compares a prefix.
