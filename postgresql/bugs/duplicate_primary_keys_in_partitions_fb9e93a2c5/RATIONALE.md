# Rationale
- File/function: src/backend/catalog/index.c, index_check_primary_key()
- Traces to the single fix_impl.patch hunk: the condition `(is_alter_table || heapRel->rd_rel->relispartition) && relationHasPrimaryKey(heapRel)` is reduced back to `is_alter_table && relationHasPrimaryKey(heapRel)`. CREATE TABLE ... PARTITION OF therefore no longer rejects a second primary key, so a partition can end up with duplicate primary keys. The comment was left unchanged.

Failing oracle case: src/test/regress||indexing
