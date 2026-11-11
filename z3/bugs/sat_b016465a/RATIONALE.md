Reintroduced the pre-fix design from FIX.diff (#5454): extension assumptions are collected by scanning the
SAT trail after add_assumptions(), instead of being inserted explicitly into the assumption set.
Assumptions already assigned (so not pushed on the trail) are missed from m_ext_assumption_set.

Hunks:
- sat/sat_extension.h: add_assumptions(literal_set&) -> add_assumptions()  (FIX hunk 1)
- sat/sat_solver.cpp init_ext_assumptions: restore trail_size + trail scan insert loop (FIX hunk 2)
- sat/smt/euf_solver.{h,cpp}: signature revert, forwarding without set (FIX hunks 3-4)
- sat/smt/recfun_solver.{h,cpp}: signature revert, drop explicit assumptions.insert, plain assign_scoped (FIX hunks 5-6)

Final ./check.sh: BUILD OK
FAIL z3test:issues/5454.smt2 (rc=114): ASSERTION VIOLATION sat_solver.cpp:2615 Failed to verify: idx > 0
(expected "sat" output missing)
