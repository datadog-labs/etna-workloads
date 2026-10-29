repro.sql is the fuzz-1.18 query. A subquery has an empty FROM clause, so the buggy WHERE setup sets `pWInfo->iContinue` from `a[-1]` after the loop, and the value is never set properly.
Clean shell: exits 0 and prints a blank line (the query returns NULL, which the shell shows as an empty line).
Buggy shell: aborts with `sqlite3WhereContinueLabel: Assertion 'pWInfo->iContinue!=0' failed` (exit -6).
