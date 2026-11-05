# Rationale

Reverts the fix "Fix LATERAL references to target table of UPDATE/DELETE".

Changes, both in src/backend/parser/analyze.c:

1. `transformDeleteStmt`: removed the block that sets `nsitem->p_lateral_only = true`
   and `p_lateral_ok = false` before `transformFromClause(pstate, stmt->usingClause)`.
   This traces to the fix.patch hunk adding `nsitem->p_lateral_only = true` before the USING clause.
2. `transformUpdateStmt`: same removal before `transformFromClause(pstate, stmt->fromClause)`.
   This traces to the fix.patch hunk adding `p_lateral_only = true` before the FROM clause.

Without these, the target relation is not marked LATERAL-only while the
FROM/USING clause is transformed. Subqueries in FROM/USING can then reference the
target table without LATERAL, and the LATERAL-reference handling is wrong.

Failing oracle cases (confirmed by agent_oracle.py): src/test/regress||join
