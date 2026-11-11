# Rationale
Hunk: src/src/smt/smt_solver.cpp (core extension loop) traces to the smt_solver.cpp hunk of FIX.diff.
Restored the pre-fix code: SASSERT(contains) + unchecked find(name), instead of a guarded find(name, f).
Core literals that are not in m_name2assertion then hit the assertion/invalid lookup (issue #3587).
The mpz.cpp hunk is not reintroduced (cosmetic/not needed for the oracle).

Final check.sh result:
FAIL z3test:smt2/3587.smt2 (rc=110)
