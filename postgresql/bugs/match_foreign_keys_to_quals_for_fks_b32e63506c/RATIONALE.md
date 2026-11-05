# Rationale

Changed hunk: src/backend/optimizer/plan/initsplan.c, match_foreign_keys_to_quals().
Traces to the single hunk of fix.patch. The fix replaced find_base_rel() with direct
simple_rel_array lookups that skip FKs whose rels have no RelOptInfo (rtable entries
not in the jointree, or removed by join removal). I restored the find_base_rel() calls
and dropped the NULL/size checks, so such FKs now raise "no relation entry for relid N".

Failing oracle case: src/test/regress||foreign_key
