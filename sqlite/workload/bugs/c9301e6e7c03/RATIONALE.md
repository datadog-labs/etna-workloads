# Rationale

Fix hunks (src/select.c, findConstInWhere): added `sqlite3ExprAffinity(pLeft)==0`
and `sqlite3ExprAffinity(pRight)==0` before constInsert(). In 3.54.1 that check
lives in constInsert() as `if( sqlite3ExprAffinity(pValue)!=0 ) return;` (also
listed in its header comment, "Do not add if pValue has an affinity"). Both
findConstInWhere call sites funnel through it, so deleting that one line is
equivalent to reverting both hunks: constant expressions with affinity (e.g.
CAST(0 AS INT) from a flattened view) are propagated again.

Oracle failures: whereL-500, 510, 520, 530 (the ticket 82ac75ba0093e5dc join
cases) return a row instead of an empty result.
