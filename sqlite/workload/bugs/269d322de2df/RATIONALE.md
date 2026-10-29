# Reintroduced bug: COLLATE on first term of a vector ignored (ticket 135c9da7513e5a97)

## Changes
1. `src/expr.c` `sqlite3ExprCollSeq()`: TK_VECTOR no longer descends into the first
   list element (only the TK_FUNCTION/SQLITE_AFF_DEFER case remains). Reverses the
   fix's `if( op==TK_VECTOR ){ p = p->x.pList->a[0].pExpr; continue; }` hunk
   (today merged into a combined condition).
2. `src/parse.y` vector rule: removed propagation of EP_Propagate flags (EP_Collate)
   from the elements to the TK_VECTOR node. Reverses the fix's parse.y hunk
   (today a loop over all elements). Without it, the later EP_Collate scan in
   ExprCollSeq cannot find the COLLATE either, so both paths are needed.

The treeview.c hunk is debug output only and was not reverted.

## Oracle failures
rowvalue-25.10, 25.20 (vector compare with COLLATE on the constraint side's first term
uses BINARY, so 'a' < 'B' NOCASE gives wrong result). rowvalue-36.0-36.2 also fail
(extra rows returned), a consequence of the same collation loss.
