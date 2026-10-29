repro.sql is gencol1-6.10: REPLACE into a table whose generated column is NOT NULL and evaluates to NULL.

- Clean shell: `Error near line 2: NOT NULL constraint failed: t0.c0`, exit 1.
- Buggy shell: assertion failure in sqlite3VdbeExec (`pOp->p1>=0 && pOp->p1<p->nCursor`), exit 134. The injection makes the REPLACE conflict path try to substitute the generated column's expression as a default.

I couldn't run `./check.sh`: it failed in the sandbox with a bwrap error. I ran both shells directly instead.
