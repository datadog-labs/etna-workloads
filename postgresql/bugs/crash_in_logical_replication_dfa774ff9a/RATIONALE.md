# Rationale

## Hunks
1. `src/backend/utils/cache/relcache.c`, `RelationGetIndexAttrBitmap()` (and the `#include "catalog/index.h"` line).
   Traces to the whole fix.patch relcache.c hunk. It reverts the per-index loop to
   `BuildIndexInfo()` and reads `ii_Unique`, `ii_Expressions`, `ii_Predicate`, `ii_NumIndexAttrs`,
   `ii_IndexAttrNumbers` and `ii_NumIndexKeyAttrs` from it. `BuildIndexInfo` calls
   `RelationGetIndexExpressions`/`RelationGetIndexPredicate`, which run `eval_const_expressions()`
   on every index of the table. That can need a snapshot that isn't set.
2. `src/backend/replication/logical/proto.c`, `logicalrep_write_attrs()`.
   The publisher code path from fix.patch (pgoutput calling `RelationGetIndexAttrBitmap` for the
   replica identity) has since been split out into `RelationGetIdentityKeyBitmap()`, which no longer
   goes through BuildIndexInfo. I call `RelationGetIndexAttrBitmap(rel, INDEX_ATTR_BITMAP_IDENTITY_KEY)`
   again so the publisher hits the reverted code. This is the adaptation of the "publisher" half of the original bug.
   The subscriber half no longer reproduces, because `begin_replication_step()` now pushes a snapshot.

## Failing oracle cases
All 20 cases in src/test/subscription t/100_bugs.pl fail (the script dies on the publisher crash from the
partial index `WHERE a > double(1)`), including "index predicates do not cause crash".
