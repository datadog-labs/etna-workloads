# Rationale

Changed hunk: `src/src/sat/smt/distinct_theory_checker.cpp`, `theory_checker::check`.
Traces to the FIX.diff hunk creating `distinct_theory_checker.cpp`, which replaced the
old native alldiff plugin that returned true for every hint with a real gate-clause check.
`check` now returns true unconditionally, so any clause with an `alldiff` hint replays as valid
(e.g. `(or (= a b) (= a c) (= b c))` with an alldiff hint and no assumption). This is the
original bug. The other fix hunks (input status for root distinct clauses, removal of unused
overloads) are already in this tree and were left alone.

check.sh result: proof_replay FAIL (assertion at proof_replay.cpp:458,
`!check("(assert (distinct a b c))(assert (not (or (= a b) (= a c) (= b c))))")` failed).
