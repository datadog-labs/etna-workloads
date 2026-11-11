# Rationale

One hunk, src/src/opt/optsmt.cpp (geometric search, after `m_s->maximize_objective`):
removed `m_upper[obj_index] = search.upper();` following `search.update(result);`.

Traces to the optsmt.cpp hunk of FIX.diff at `@@ -218,17 +213,11 @@`, which replaced the
old inline publishing of `result.upper_bound` into `m_upper` with
`search.update(result); m_upper[obj_index] = search.upper();`. The fix's stated bug is
that a certified/refuted upper bound was not published before further search, so an
interruption lost the cap. Without the publish line, the cap is held only in the local
`objective_search` and `m_upper` stays at its weaker value (oo) until later transitions.

Final ./check.sh: BUILD OK; FAIL opt_bounds (rc=114), assertion at opt_bounds.cpp:397
("certified nonlinear dual bounds": upper=oo, expected 2).
