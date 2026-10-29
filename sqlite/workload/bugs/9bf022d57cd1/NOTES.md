repro.sql creates a trigger whose body calls an unregistered window function, `a(*) OVER (ORDER BY (SELECT 1))`, then runs ALTER TABLE RENAME.
Clean shell: the rename succeeds and the script prints `done`.
Buggy shell: it aborts on the assertion `p->selFlags & SF_Resolved` in selectAddSubqueryTypeInfo (exit status -6). The injection stops treating an unregistered window-function call as an aggregate during name resolution, so the subquery is left unresolved.
