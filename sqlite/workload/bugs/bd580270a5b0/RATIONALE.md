# Rationale

## src/build.c, convertToWithoutRowidTable()
Reverses the fix's only implementation hunk: non-PK columns appended to the
WITHOUT ROWID PRIMARY KEY index get `sqlite3StrBINARY` again instead of the
column's declared collation (`sqlite3ColumnColl()`), so `Index.azColl[]` is wrong
for those columns.

## src/where.c, whereRangeVectorLen()
Reverting build.c alone does not fail any oracle case: the check
`sqlite3StrICmp(pColl->zName, pIdx->azColl[i+nEq])` rejects the mismatched
column (BINARY in the index vs NOCASE in the comparison), so the vector range
is truncated and the result is correct. That check covers the same case from
another path. I restrict it to key columns (`i+nEq<pIdx->nKeyCol`), so the
non-key columns appended to a WITHOUT ROWID PK are no longer checked. Those
are exactly the columns whose azColl the fix corrected. Removing the check
completely also broke rowvalueA-5.2, so I narrowed it.

## Oracle failures
rowvalueA-4.1, rowvalueA-4.3 (the fix's new tests) and rowvalueA-3.3: the
row-value range seek uses the BINARY collation for a NOCASE non-PK column, so
rows that should match are missed.
