# Rationale

## src/select.c, substExpr()
Reverses the single implementation hunk of fix.patch. The fix turned
`else if( op==TK_IF_NULL_ROW && iTable==pSubst->iTable ){ iTable = iNewTable; } else { recurse }`
into an `if` nested inside the recursing `else`, so that the operand (pLeft) of a
TK_IF_NULL_ROW is also rewritten. I restored the `else if` form: the iTable is
updated but the substructure (pLeft etc.) is not descended into. The other code
in the else branch (TK_AGG_FUNCTION adjustment, added later) is untouched.

## Oracle failures
join-14.3 (the case the fix added) fails with an assertion failure
`sqlite3VdbeExec: Assertion 'pC!=0' failed`: the column reference inside the
IF_NULL_ROW still points at the flattened-away subquery's cursor.
