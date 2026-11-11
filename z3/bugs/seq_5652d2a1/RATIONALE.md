Changed src/src/smt/mam.cpp, undoing two hunks of FIX.diff's smt/mam.cpp part:
1. `instruction* m_next = nullptr;` -> `instruction* m_next;` (uninitialised again, as before the fix).
2. Removed `if (!m_pc) goto backtrack;` at main_loop, so a null pc is dereferenced again.
Together they reintroduce the #5429/#5431 crash (segfault in the MAM).
The seq_rewriter hunks were cosmetic (removing #if 0 code) and not reverted.

Final ./check.sh output:
BUILD OK
FAIL z3test:issues/5429.smt2 (rc=139)  (segfault)
