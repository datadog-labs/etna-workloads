`repro.sql` is the triggerG-100/110 case: with recursive_triggers on, a recursive AFTER INSERT trigger runs a `SELECT ... WHERE a IN (1,2,3,4)` over an indexed table, which uses OP_Once.
Clean shell prints 202 203 302 303 402 403 502 503 and exits 0.
Buggy shell hits the assertion `pC!=0` in sqlite3VdbeExec and aborts (exit -6), because OP_Once misbehaves in recursive trigger frames.
