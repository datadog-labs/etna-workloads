# Rationale

## src/backend/rewrite/rewriteHandler.c, view_query_is_auto_updatable()
Traces to the rewriteHandler.c hunk of fix_impl.patch: removed `base_rte->relkind != RELKIND_PARTITIONED_TABLE`
from the check on the view's base relation kind. Views over partitioned tables are again reported as
"not automatically updatable". The executor hunk (WCO for partitions) was reworked upstream and is not needed to reproduce the failure.

## Failing oracle cases
- src/test/regress||updatable_views
