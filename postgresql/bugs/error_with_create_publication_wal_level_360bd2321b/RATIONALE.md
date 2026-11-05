# Rationale
Reverse of fix.patch, adapted to current code:

1. src/backend/catalog/pg_publication.c, check_publication_add_relation(): the unlogged-table check was `relpersistence == RELPERSISTENCE_UNLOGGED`; now `!RelationNeedsWAL(targetrel)` (fix hunk 1). Under wal_level=minimal, new permanent tables in the same transaction don't need WAL, so CREATE PUBLICATION wrongly errors "unlogged tables".
2. src/backend/optimizer/util/plancat.c, get_relation_info(): `!RelationIsPermanent(relation)` -> `!RelationNeedsWAL(relation)` (fix hunk 2), same wrong persistence test during recovery.

Failing oracle case: see run output (CREATE PUBLICATION while "wal_level=minimal" in src/test/subscription t/001_rep_changes.pl).
