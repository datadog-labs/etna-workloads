# Rationale

## src/parse.y (seltablist ::= stl_prefix LP seltablist RP as on_using)
Reverses the fix hunk that added the `if( pOld->fg.isTabFunc ){ ... }` block
which moves `u1.pFuncArg` and the `isTabFunc` flag from the inner FROM item to
the new item. In 3.54.1 that block sits in front of the `isIndexedBy` branch
(`else if`), so I removed it and left `if( pOld->fg.isIndexedBy )`. Without it,
a parenthesized table-valued function with an alias,
`(generate_series(1,5,2)) AS x`, loses its arguments and the TVF flag.

## Oracle failures
`tabfunc01-4.4` (`SELECT * FROM (generate_series(1,5,2)) AS x LIMIT 10`) fails.
The unaliased case (json-15.120) goes through the `A = F` shortcut and is unaffected.
