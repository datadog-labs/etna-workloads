# Rationale

File: src/backend/catalog/heap.c, function heap_truncate_find_FKs()
Traces to the single fix_impl.patch hunk set in heap.c: the removed pre-fix code is restored.
The oids copy, parent_cons tracking, the second pass that climbs conparentid to the top-level
constraint, and the restart loop are all removed. The function again only looks at FKs whose
confrelid is directly in the input list. For TRUNCATE ... CASCADE on a partition referenced
by a partitioned table's FK, the referencing tables (which point at the top-level parent) are
not found, so they're not truncated and the FK check errors or behaves incorrectly.

Failing oracle case: src/test/regress||truncate
