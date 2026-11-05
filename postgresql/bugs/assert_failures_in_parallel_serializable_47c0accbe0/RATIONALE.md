# Rationale

All changes are in `src/backend/storage/lmgr/predicate.c`; they reverse the three hunks of fix_impl.patch.

1. `ReleasePredicateLocks()`: removed the `partiallyReleasing` local and its assignment in the partial-release branch. This reverses hunks 1 and 2.
2. `ReleasePredicateLocks()`, SxactGlobalXmin reference release: the condition is back to `TransactionIdEquals(xmin, SxactGlobalXmin)` alone. This reverses hunk 3. When the function runs a second time for a parallel read-only transaction, it decrements `SxactGlobalXminCount` again. That trips the `Assert(SxactGlobalXminCount > 0)` or corrupts the count.
3. `PreCommit_CheckForSerializationFailure()`: restored the unconditional doomed check and `Assert(!SxactIsPartiallyReleased(...))`. This reverses hunk 4. A partially released transaction sets its own DOOMED flag, so the assert now fails.

Oracle cases that fail: `src/test/isolation||serializable-parallel-2` and `src/test/isolation||serializable-parallel-3`.
