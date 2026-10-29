# Rationale

Only hunk: `src/resolve.c`, `lookupName()`, the "Perhaps the name is a reference to the ROWID" block. The fix changed `cntTab==1` to `cntTab>=1` and `cnt = 1` to `cnt = cntTab`. The code was unchanged apart from the `pSTab` rename, so I reverted both lines to `cntTab==1` and `cnt = 1`.

Effect: an unqualified `rowid` that could refer to several tables in the FROM clause no longer yields cnt>1 ("ambiguous column name: rowid"). The lookup falls through to "no such column: rowid", or in some nested-join cases hits an assertion.

Oracle: `unionall-5.30` crashes with `Assertion 'n < pExTab->nCol' failed` in sqlite3ExprColUsed. The expected result was "ambiguous column name: rowid". The joinH 9.1–9.3 and rowid 16.9 cases should fail with "no such column: rowid". I only saw the unionall crash, because the run aborted there.
