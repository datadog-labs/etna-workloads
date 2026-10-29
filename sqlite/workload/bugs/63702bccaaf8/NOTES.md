Reproducer (`repro.sql`): a WITHOUT ROWID table joined with a nested FROM `(x1 JOIN x2)`, then selecting the unqualified `rowid`.

The clean shell reports `ambiguous column name: rowid`. The buggy shell reports `no such column: rowid`, because it no longer resolves unqualified rowid matches in nested joins. This is the joinH-9.2 and 9.3 failure.
