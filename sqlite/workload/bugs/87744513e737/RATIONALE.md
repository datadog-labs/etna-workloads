# Rationale

The 2014 fix added a column-cache push/pop (`sqlite3ExprCachePush` and `sqlite3ResolvePartIdxLabel`) around the partial-index WHERE code in `sqlite3GenerateIndexKey()`. This kept the cache from claiming registers were loaded when the code that loads them had been jumped over. The column cache no longer exists in 3.54.1, so that hunk cannot be reversed directly. The current equivalent is the `pPrior` / `regPrior` register reuse in `sqlite3GenerateIndexKey()`. It is guarded in the same way against partial indexes whose key code may be skipped.

## Changes (src/delete.c, sqlite3GenerateIndexKey)
- Removed `pPrior = 0` after coding `pPartIdxWhere`. This reverses the fix's push of a fresh cache level before the partial-index WHERE code. Registers set up before the WHERE code are no longer treated as untrusted afterwards.
- Removed `|| pPrior->pPartIdxWhere` from the `pPrior` reset. This reverses the fix's pop on resolving the jump-over label. A skipped partial index no longer invalidates the prior-key reuse, so columns can be treated as "already computed" when the code that computed them was jumped over.

Both changes restore the pre-fix behaviour of treating registers as valid when the code that loaded them may have been skipped.

## Oracle result
`./check.sh` shows `index6-1.1` aborting with `Assertion memIsValid(&r.aMem[ii]) failed` in `sqlite3VdbeExec`. The run is incomplete, so all 72 `index6.test` oracle cases count as failing. This is a register-validity assertion, like the assertion fault the ticket describes.
