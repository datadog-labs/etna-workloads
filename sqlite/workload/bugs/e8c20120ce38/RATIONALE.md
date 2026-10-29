# Rationale

## Change
`tree/ext/fts5/fts5parse.y`: the `exprlist ::= exprlist cnearset` rule again calls
`sqlite3Fts5ParseNode(pParse, FTS5_AND, X, Y, 0)` instead of
`sqlite3Fts5ParseImplicitAnd(pParse, X, Y)`.

This reverses the fix's fts5parse.y hunk. The other hunks of the fix (ParseImplicitAnd itself,
EOF handling in ParseNode/ExprFirst, printing) are still present in 3.54.1 but ParseImplicitAnd is
now unused. Without it, an implicit AND with an empty-phrase operand (`"" a`) is built as a real
AND node containing an EOF child, so the empty phrase is not dropped from the implicit AND, which was the pre-fix behaviour.

## Oracle failures
`fts5fuzz1-2.2.3`: `SELECT rowid FROM f1('"" a')` expected `{1 2}`, got `{}`.
