# Rationale

File: src/backend/optimizer/plan/setrefs.c, function add_rtes_to_flat_rtable.

Traces to the fix.patch setrefs.c hunk that added the dead-subquery pass. That pass copies RTEs
from excluded or dummy subqueries into the flat rtable so the executor still checks permissions
on them. The edit removes the two calls in that pass: `flatten_unplanned_rtes` for subqueries
that were never planned, and the recursive `add_rtes_to_flat_rtable` for subqueries whose plan
is dummy. Relations inside excluded subqueries are then missing from the final rangetable, so
their permission checks are skipped. The old createplan.c SubqueryScan workaround is not
restored, so nothing else covers this.

Oracle case expected to fail: src/test/regress||privileges
