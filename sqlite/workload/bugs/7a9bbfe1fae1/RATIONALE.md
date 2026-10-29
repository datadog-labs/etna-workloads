# Rationale

Fix: stop calling the partial-index constant-column analysis at CREATE INDEX /
schema-parse time (where an unknown collation in the WHERE clause raised an error,
making the schema "malformed"); only run it in whereLoopAddBtree / WhereBegin.

Changes (all reverse fix hunks):
- src/build.c `recomputeColumnsNotIndexed`: takes `Parse*` again and, for a partial
  index, calls the analysis to clear colNotIdxed bits (reverses hunk 1).
- src/build.c `sqlite3CreateIndex`: restored `if( pParse->nErr ) goto exit_create_index;`
  after that call (reverses hunk 2). The PK caller passes pParse too.
- src/where.c / src/sqliteInt.h: `wherePartIdxExpr` made non-static again as
  `sqlite3WherePartIdxExpr` with a prototype (reverses the sqliteInt.h hunk). Its
  `Bitmask *pMask` form is used with `&pIdx->colNotIdxed`, which is equivalent to the
  old direct `pIdx->colNotIdxed &= ...`.

Oracle failure: indexA-5.3. After `CREATE INDEX ... WHERE b IS 'abc' COLLATE xyz`
with a Tcl-defined collation, reopening the DB fails with
"malformed database schema (ex1) - no such collation sequence: xyz".
