# Rationale

## src/resolve.c, resolveExprStep, case TK_EXISTS/TK_SELECT/TK_IN
Reverses the single implementation hunk of the fix. The fix replaced
`sqlite3ResolveNotValid(..., NC_IsCheck|NC_PartIdx|NC_IdxExpr|NC_GenCol)`
followed by an unconditional `sqlite3WalkSelect()` with a test of `NC_SelfRef`
(report the error, otherwise walk). The tree already had the fixed form, so I
restored the pre-fix form, adapted to the current 6-argument macro
(`sqlite3ResolveNotValid(P,N,M,X,E,R)`). A subquery in a generated column now
reports the error but still walks the subquery. When the subquery references
a virtual table (rtree), that walk reaches sqlite3_declare_vtab() during
schema init (`db->init.busy`), which trips its assert.

## Oracle
vtabK-300 fails: `testfixture: sqlite3_declare_vtab: Assertion 'db->init.busy==0' failed`,
which aborts the run. The earlier vtabK cases pass.
