# Rationale
Only the euf-plugin hunk of FIX.diff (negation_violated + has_id, and its call in the conflict check in euf_proof_checker.cpp) was undone: removed them, so (not x) inside equalities is again treated as uninterpreted and x = (not x) is not detected as a conflict.
The theory_checker::check hunk (double-negation comparison) could not be reverted verbatim: the code was refactored into clause_follows; I left it untouched.
Result of ./check.sh:
FAIL proof_checker (rc=114)
(proof_checker fails: Failed to verify check({m.mk_eq(x, nx)}) at test/proof_checker.cpp:92)
