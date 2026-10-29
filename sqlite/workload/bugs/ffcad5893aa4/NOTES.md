repro.sql is the delete-12.0 case from test/delete.test. It runs a DELETE whose WHERE clause has a short-circuit and an uncorrelated subquery on the same table.

- Clean shell: prints `8|4|95`, which is correct.
- Buggy shell: prints `2|2|`. The one-pass DELETE is wrongly allowed, so the subquery runs after some rows are already deleted and gives a different answer. Row (2,2,NULL) is kept when it should have been deleted.

I ran both shells directly on repro.sql. `./check.sh` failed in the sandbox with a bwrap error, so it was not run.
