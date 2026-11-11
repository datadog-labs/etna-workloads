One hunk, src/ast/ast.cpp ast_manager::mk_modus_ponens, traces to the first hunk of FIX.diff.
The fix changed `if (!p1 || !p2) return nullptr;` to `if (!p2 || !p1) return p1;`. In today's code the fixed form was present, so I restored the old form (return nullptr when either proof is null).
Effect: when p2 is null but p1 is not, the proof of the original fact is lost, which is the bug. Proof-producing tactics (lia2card) then call goal::update with a null proof, and this trips the assertion at goal.cpp:288. z3test:smt2/3286.smt2 now fails with an ASSERTION VIOLATION where it expects "sat".
The other hunks of FIX.diff (card2bv, lia2card proof construction, tracing, is_well_formed) have no counterpart in today's code, which was rewritten, so I did not change them.

Final ./check.sh:
BUILD OK
FAIL z3test:smt2/3286.smt2 (rc=110)  (ASSERTION VIOLATION, goal.cpp line 288)
