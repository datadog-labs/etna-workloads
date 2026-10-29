# Rationale

Fix hunk (src/where.c, whereLoopAddBtreeIndex): added `pNew->aLTerm[i] &&` before dereferencing
`aLTerm[i]->pExpr` in the loop that detects earlier terms from the same `IN (SELECT...)` expression.
On a skip-scan, aLTerm[] slots for skipped columns are NULL.

Change: in tree/src/where.c (~line 3349) removed the `pNew->aLTerm[i] &&` NULL guard, restoring the
pre-fix unguarded dereference. This is the only changed line.

Oracle: skipscan1-9.2 (`b IN (SELECT ...)` with skip-scan on unconstrained first index column)
dereferences a NULL aLTerm entry and crashes; the run ends at skipscan1-9.2 with no result.
