# Rationale

The 3.54.1 code still has the fixed form (`NC_Subquery`), so the fix is reversed by hand, hunk by hunk.

- `src/resolve.c` (resolveExprStep, TK_SELECT/TK_EXISTS/TK_IN): the fix moved `pNC->ncFlags |= ...` out of the `if( nRef!=pNC->nRef )` block, so it is set for every subquery. Reverted: the flag is set only inside the correlated-subquery check.
- `src/sqliteInt.h`: the flag is renamed back to `NC_VarSelect` ("A correlated subquery has been seen"), same value 0x40.
- `src/delete.c` (sqlite3DeleteFrom): the check goes back to `sNC.ncFlags & NC_VarSelect`. An uncorrelated subquery that reads the target table no longer sets bComplex. The one-pass multi-row DELETE optimization stays enabled, so the subquery can run after rows are already deleted.

## Oracle
`test/delete.test` delete-12.0 fails. It expected `8 4 95` and got `2 2 {}`, because the uncorrelated subquery `SELECT vkey FROM t0 ... LIMIT 1 OFFSET 2` is evaluated lazily after earlier rows are deleted. The other 67 cases pass.
