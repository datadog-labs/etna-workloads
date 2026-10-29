Reproducer (`repro.sql`): a window function that uses a named WINDOW whose PARTITION BY contains a sub-select (`b IN (SELECT rowid FROM t7)`), from window1-16.2.

Clean shell returns rows `2|10`, `1|101`, `3|101`. The buggy shell aborts with an assertion failure (`selectAddSubqueryTypeInfo: Assertion '(p->selFlags & SF_Resolved)' failed`). The injection walks the window's PARTITION BY/ORDER BY/FILTER before `sqlite3WindowUpdate` merges in the named window definition, so the sub-select inside the named window is never resolved.
