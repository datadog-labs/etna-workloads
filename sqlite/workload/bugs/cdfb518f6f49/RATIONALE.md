# Rationale

Bug: a Bloom filter built on an expression index (forum posts 2e427099d5, d47a0e8e3a).

Changes, all in `src/where.c`, function `sqlite3ConstructBloomFilter`:

1. Reverses the fix's second hunk. The filter-population loop again reads
   `pIdx->aiColumn[jj]` and calls `sqlite3ExprCodeGetColumnOfTable()`. The fix had
   replaced that with `sqlite3ExprCodeLoadIndexColumn()`. For an expression-index
   column `aiColumn` is `XN_EXPR`, and the old call cannot evaluate it. It emits
   OP_Rowid, or hits the `assert( iCol!=XN_EXPR )` in debug builds. That assert is
   the fix's `expr.c` hunk and already exists in 3.54.1.
2. Reverses the fix's first and third hunks. The save, clear and restore of
   `Parse.pIdxEpr` is removed. Without it, expressions in the filter-building code
   can be substituted with index columns of a cursor that is not open at that point.
   The save/restore of `pIdxPartExpr` was added later and is left alone.

Oracle: 14 of 27 cases in `test/bloom1.test` fail. `bloom1-4.2` aborts on
`Assertion iCol!=XN_EXPR failed` in `sqlite3ExprCodeGetColumnOfTable`. Cases 4.3 to 7.6
fail because the run aborts at that point.
