# Rationale

Fix (2019-12-20, ticket e0a8120553f4b082): a TK_COLUMN for a REAL generated
column whose value is extracted from an index got an OP_RealAffinity, because
the index stores 1.0 as integer 1.

In 3.54.1 the `y.pTab==0 && affExpr==REAL` path no longer exists. A virtual
generated column is coded by `sqlite3ExprCodeGeneratedColumn()` (src/expr.c),
which codes the column expression -- possibly resolved to an index read via
`sqlite3IndexedExprLookup()` (OP_Column on the index cursor, integer 1) -- and
then applies the column affinity with OP_Affinity. For REAL that OP_Affinity is
what turns the index-read integer back into a real, i.e. the modern equivalent
of the fix's OP_RealAffinity.

## Change
src/expr.c, `sqlite3ExprCodeGeneratedColumn`: the OP_Affinity is no longer
emitted for REAL columns (`&& pCol->affinity!=SQLITE_AFF_REAL`). This reverses
the fix hunk (adding real affinity to generated REAL columns read from an
index) by dropping the real conversion again.

## Oracle failures
gencol1-17.10, 17.20, 17.30 (the tests the fix added) fail: the REAL generated
column `c0 REAL AS(1) UNIQUE` returns integer 1 instead of 1.0, and the
BETWEEN comparisons give wrong results.
