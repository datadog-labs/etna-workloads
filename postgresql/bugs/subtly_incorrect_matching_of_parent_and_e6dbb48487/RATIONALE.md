# Rationale

File: src/backend/commands/indexcmds.c, function DefineIndex (partitioned-table branch).

Traces to the fix_impl.patch hunks, reversed:
1. Removed the `indexInfo = BuildIndexInfo(parentIndex)` rebuild (with its comment).
   The parent IndexInfo is again the one built from the IndexStmt, which has not
   been through expression preprocessing (e.g. predicate), so it can mismatch the
   child IndexInfo.
2. Re-added `opfamOids[]`, computed from `opclassIds` with get_opclass_family(),
   and passed in place of `parentIndex->rd_opfamily` to CompareIndexInfo.
3. Pass `collationIds` instead of `parentIndex->rd_indcollation` to CompareIndexInfo.
   Collation and opfamily arrays are no longer taken from the real parent index.
`parentIndex` is still opened/closed because current code also uses it for
generateClonedIndexStmt; that part postdates the fix.

Failing oracle case: src/test/regress||indexing (expected; see oracle output)
