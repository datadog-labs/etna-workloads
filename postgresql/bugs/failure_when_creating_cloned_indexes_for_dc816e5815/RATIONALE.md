# Rationale

## src/backend/commands/tablecmds.c, DefineRelation (inherited-index cloning loop)
Traces to the single fix.patch hunk, which changed the natts argument passed to
generateClonedIndexStmt from `RelationGetDescr(parent)->natts` (correct) back to
`RelationGetDescr(rel)->natts` (bug).

In current code generateClonedIndexStmt no longer takes a natts argument: the
AttrMap carries its own length (`maplen`), which build_attrmap_by_name sets to the
parent's natts. I reintroduced the bug by setting `attmap->maplen = RelationGetDescr(rel)->natts`
right before the call. The map length is then the partition's natts rather than the
parent's. When the parent has more attribute slots than the partition (e.g. dropped
columns), indexed Vars beyond the map length are rejected in map_variable_attnos, so
cloned index creation fails.

## Failing oracle cases
- src/test/regress||create_table
