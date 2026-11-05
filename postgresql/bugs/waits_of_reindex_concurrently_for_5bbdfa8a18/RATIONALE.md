# Rationale
- File/function: src/backend/commands/indexcmds.c, ReindexRelationConcurrently.
- Traces to the fix_impl.patch hunk that changed `idx->safe` to use RelationGetIndexExpressions()/RelationGetIndexPredicate().
- Reverted to read `indexRel->rd_indexprs` / `rd_indpred` directly. These relcache fields are only populated lazily, so they are NIL when not yet loaded. Indexes with expressions or predicates are then wrongly marked safe, and REINDEX CONCURRENTLY skips waiting for them.
- The injection-point hunk is left in place because it is test instrumentation, and the test needs it.

Failing oracle case: src/test/modules/injection_points||reindex_conc
