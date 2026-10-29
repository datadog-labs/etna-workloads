Reproducer (repro.sql): a CTE whose SELECT uses a window function, queried by an outer SELECT that also uses a window function (window1-9.3).

Clean shell prints three rows. The buggy shell aborts with the assertion `(p->selFlags & SF_HasTypeInfo)==0` in selectAddSubqueryTypeInfo (exit status -6), because the injection replaces the early return with an assert.
