# Rationale

Hunk: src/backend/optimizer/path/allpaths.c, `subquery_is_pushdown_safe()`.

Traces to fix.patch hunk adding the call `check_output_expressions()` for leaf queries (`if (subquery->setOperations == NULL)`) so that every arm of a UNION/INTERSECT tree has its output expressions checked (set-returning, volatile, DISTINCT ON columns). The bug is reintroduced by calling it only for the top-level query (`subquery == topquery`). Output columns of set-op arms that are unsafe (e.g. volatile or SRF) are then not marked unsafe, so WHERE clauses get pushed down into unsafe UNION/INTERSECT nests.

Failing oracle case: src/test/regress||union
