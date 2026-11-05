# Rationale
- File: src/backend/optimizer/plan/setrefs.c, function flatten_rtes_walker(). Traces to the only hunk of fix.patch.
- The change removes the save/restore of cxt->query around the query_tree_walker call for a nested Query. After a sub-select is walked, cxt->query stays pointing at the sub-query. The remaining RTEs of the outer query are then matched against the wrong rteperminfos. This is the buggy recursion.
- Failing oracle case: src/test/regress||join (confirmed FAIL in the oracle run)
