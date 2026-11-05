Changes (the signature/brin hunks of fix_impl.patch are refactoring already in tree; only the missing calls are reverted):

1. src/backend/catalog/index.c, validate_index(): removed the index_insert_cleanup(indexRelation, indexInfo) call after tuplesort_end (fix.patch hunk in validate_index). Cached AmCache (e.g. BRIN insert state) is no longer released.
2. src/backend/commands/constraint.c, unique_key_recheck(): removed the index_insert_cleanup call after index_insert (fix.patch constraint.c hunk). Same leak of indexInfo->ii_AmCache.

Failing oracle case: src/test/regress||brin
