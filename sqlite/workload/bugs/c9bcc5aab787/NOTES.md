repro.sql runs the where7 4.1 case: a multi-index OR `(z=222 OR y=111)` with an extra AND term holding a correlated EXISTS subquery.

- Clean shell: prints `111`, exit 0.
- Buggy shell: the subquery term is pushed into the OR branches. The subroutine ends up with index references from a different branch's index, so an assertion fails in sqlite3VdbeExec (`p2<(u32)pC->nField ...`) and the shell aborts with exit 134.

I couldn't run `./check.sh` because the sandbox blocked it (bwrap error). I ran both shells directly instead.
