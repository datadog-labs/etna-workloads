repro.sql is select7-4.2: a correlated NOT EXISTS subquery containing a compound SELECT (EXCEPT) that refers to the outer query's P.pk.

The clean shell prints rows `2` and `3`, exit 0.
The buggy shell aborts (exit 134) with `selectAddSubqueryTypeInfo: Assertion '(p->selFlags & SF_Resolved)' failed`. The injection stops name resolution after the first SELECT of a compound whenever there is an outer name context, so the other SELECTs are never resolved.

I ran both shells directly instead of using `./check.sh`. It failed in this sandbox with a bwrap error about a missing `.claude/launch.json`.
