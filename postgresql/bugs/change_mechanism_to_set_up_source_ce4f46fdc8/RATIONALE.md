# Rationale

Most of fix_impl.patch (preptlist.c, setrefs.c comment) is already reflected in REL_18_6 in evolved form, so the only hunk re-expressed is the parser one.

## src/backend/parser/parse_merge.c, transformMergeStmt()
Traces to the fix.patch hunk in parse_merge.c: the fix replaced
`qry->targetList = expandNSItemAttrs(pstate, nsitem, 0, false, exprLocation(stmt->sourceRelation));`
with `qry->targetList = NIL;` (preprocess_targetlist sets up the source tlist). I restored the expandNSItemAttrs call (and the `nodes/nodeFuncs.h` include it needs). The parser again pre-populates the MERGE query's targetlist with the source relation's columns, instead of leaving it to the planner, which brings back the old mechanism and changes the plans/output.

## Failing oracle cases
- src/test/regress||merge
- src/test/regress||with
