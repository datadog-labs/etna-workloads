Reproducer (`repro.sql`): the with2-12.1 case — views v2/v3 with nested WITH clauses that reference themselves, then `ALTER TABLE t1 RENAME` and a SELECT from v3.

Clean shell: returns the five rows (1, 'hello', 4.25, NULL, X'3C626C6F623E'), exit 0.
Buggy shell: assertion failure `sqlite3WithPush: Assertion 'pParse->pWith!=pWith' failed`, exit 134 (the WITH clause is pushed onto the stack even after an error).
