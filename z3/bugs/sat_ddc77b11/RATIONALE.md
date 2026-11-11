# Rationale
Single hunk in src/src/sat/sat_local_search.cpp, `local_search::add_unit`: traces to the add_unit hunk of FIX.diff.
Reverted to `if (is_unit(lit)) return;`, so a unit that conflicts with an existing unit's value no longer sets `m_is_unsat`.
Local search then ignores contradictory assumptions/units and reports a bogus model, so model validation fails on 3632.smt2.
(The other hunks in FIX.diff are untouched; they are inert without this one setting m_is_unsat.)

Final ./check.sh: `FAIL z3test:smt2/3632.smt2 (rc=0)`
