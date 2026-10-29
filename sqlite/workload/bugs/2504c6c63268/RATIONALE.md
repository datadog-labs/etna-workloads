# Rationale

Fix hunk reversed: the `aFrom[0].isOrdered = nLoop>0 ? -1 : 1;` hunk in `wherePathSolver` (src/where.c).
In 3.54.1 it reads `aFrom[0].isOrdered = nLoop>0 ? -1 : nOrderBy;` inside `if( nOrderBy )`, with a comment
explaining the nLoop==0 case. I restored the pre-fix `aFrom[0].isOrdered = -1;` and removed the comment.
With no FROM clause (nLoop==0), the initial path is no longer considered ordered, so the planner
thinks a sort is needed for a query that returns at most one row.

The other fix hunk (`mxChoice = nLoop<=1 ...`) is already equivalent today (`if( nLoop<=1 )`), and is
not part of the bug as a behavioural change, so it was left alone.

Failing oracle cases: orderby1-5.0 (`EXPLAIN QUERY PLAN SELECT 5 ORDER BY 1` now emits
`USE TEMP B-TREE FOR ORDER BY` instead of nothing) and orderby1-5.1 (compound select's
plan with the sorting subquery arms).
