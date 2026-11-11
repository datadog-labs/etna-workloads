# Rationale
Changed file: src/src/sat/smt/euf_proof_checker.cpp, in smt_proof_checker::infer. The change traces to the hunk in FIX.diff that rewrites the SMT-fallback condition. The code has evolved since the original bug, so the old behaviour is restored by hand rather than by reversing the diff.

- The verification condition is initialised again as `expr_ref_vector vc(clause)`. The default plugin `vc` then appends the hint's clause. Previously it started empty and defaulted to the logged clause alone.
- The gate that discarded the plugin vc / tautology flag when the logged clause does not follow from the hint (`follows_from_hint`) is removed. A tautological hint clause can therefore make any logged clause pass as verified-smt.
- The trailing `if (vc.empty()) vc.append(clause)` is removed because it is no longer needed.

Result: the alldiff probe is accepted instead of rejected, and proof_replay fails at proof_replay.cpp:669.

check.sh result:
FAIL proof_replay (rc=114)
