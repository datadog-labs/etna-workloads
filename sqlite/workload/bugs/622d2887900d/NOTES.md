repro.sql creates main.t300 and temp.t300, then a trigger `main.r300 ON t300`. It inserts one row into each table and selects the rows that the trigger wrote to t301.

Clean shell: prints 10003, because the trigger is bound to main.t300.
Buggy shell: the trigger binds to temp.t300, so the output differs (10004).
