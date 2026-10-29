Reproducer (repro.sql): a trimmed version of with1-23.1. View v3 uses a CTE named t4 and joins view v2 (which has its own CTE also named t4) plus v3's own t4.
Without the fix, the copied view SELECTs keep duplicate selId values, so the two t4 CTEs get confused.
Clean shell: returns the 8 expected rows. Buggy shell: aborts with an assertion failure in sqlite3VdbeExec (p2<pC->nField), exit status -6.
