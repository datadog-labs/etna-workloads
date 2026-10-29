# Rationale

Fix [8a2adec1]: automatic indexes on co-routine sub-queries got a unique integer
appended to each key by turning OP_Rowid into an incrementing value (the fix
added `bIncrRowid`, `addrCounter`, `regBase`).

In 3.54.1 the mechanism lives in `translateColumnToCopy()` (src/where.c): the
OP_Rowid branch becomes `OP_Sequence` on the autoindex cursor (`iAutoidxCur`),
which supplies the unique trailing value. Only that branch was changed: it now
always rewrites OP_Rowid to `OP_Null` (p1=0, p3=0), which is the pre-fix
behaviour (the `bIncrRowid==0` path of the fix hunk). The rest of the fix
(addrCounter, regBase) is left in place; with it no longer used for the rowid,
the trailing key column is NULL for every row, so the index key is not unique.

Oracle: `autoindex5-2.1` fails: expected `8.0`, got `4.0` (duplicate rows
`('aaa',4.0)` collapse in the automatic index). Other cases pass.
