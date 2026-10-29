Reproducer (repro.sql): a trigger uses `a() FILTER (WHERE a>0)`, where `a` is not a registered function. The script renames the table, then renames column `a`.

Clean shell: both renames succeed and the trigger SQL is rewritten.
Buggy shell: it aborts with `Assertion 'pDef!=0' failed` in resolveExprStep (exit status -6).
