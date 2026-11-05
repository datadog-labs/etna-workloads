# Rationale

Reverted the fix so `CheckSelectLocking(Query *qry)` again takes no strength argument and reads it from `linitial(qry->rowMarks)`.

- `src/include/parser/analyze.h`, prototype: drops the `strength` parameter (fix.patch analyze.h hunk).
- `src/backend/parser/analyze.c`, `CheckSelectLocking`: the strength is derived from `linitial_node(RowMarkClause, qry->rowMarks)->strength` (analyze.c hunk 1/2). `transformLockingClause` calls `CheckSelectLocking(qry)` (last hunk). When the first locking clause is processed, `qry->rowMarks` is still NIL, so an invalid lock (e.g. FOR UPDATE with UNION or DISTINCT) dereferences a NULL list and crashes instead of raising the error.
- `src/backend/optimizer/plan/planner.c`, `preprocess_rowmarks`: calls `CheckSelectLocking(parse)` (planner.c hunk).

Expected failing oracle cases: the regress cases that exercise the error report of an invalid lock, such as union and possibly matview/portals.
