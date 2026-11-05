# Rationale

## src/backend/rewrite/rewriteManip.c, adjust_relid_set()
Traces to the fix.patch hunk in analyzejoins.c `replace_relid()`, which added
`bms_copy(relids)` before `bms_del_member`/`bms_add_member`. In current code
`replace_relid` has become `adjust_relid_set`, and its copy is the
`relids = bms_copy(relids);` line. I removed that line. The function now
modifies the caller's Bitmapset in place, even though the same set can be
shared among several structures (e.g. Var nullingrels, PlaceHolderVar phrels,
join relid sets). This brings back the bug that replace_relid() modified its argument.

## Failing oracle cases
- src/test/regress||join
