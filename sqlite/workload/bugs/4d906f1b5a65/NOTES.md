Reproducer: `repro.sh`. It does UPDATE ... FROM on the built-in `zipfile` virtual table, which is declared WITHOUT ROWID. This is the same case as the test's `tclvar` table.

- clean: the update works and prints `a.txt|HELLO` and `b.txt|WORLD`.
- buggy: the shell aborts with `Assertion 'pModule->xRowid' failed` in sqlite3VdbeExec (exit 134). The injection removes the WITHOUT ROWID handling in updateVirtualTable(), so the code looks up a rowid the vtab doesn't have.
