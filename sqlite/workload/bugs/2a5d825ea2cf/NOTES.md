repro.sql builds a table t1, a view v1 over it, and INSTEAD OF UPDATE and DELETE triggers on v1. It then runs `UPDATE v1 ... WHERE v1.x=2` and `DELETE FROM v1 WHERE v1.x=1`. These are the tkt3298-1.3 to 1.5 cases. It ends with a SELECT to show the resulting data.

The clean shell accepts the view-qualified column name. The update and delete take effect, and the exit status is 0.

The buggy shell fails both statements with "Parse error: no such column: v1.x". The data is left unchanged, and the exit status is 1.

I couldn't run `check.sh` because it failed in this sandbox with a bwrap error about a missing `.claude/launch.json`. I ran both shells directly on repro.sql instead.
