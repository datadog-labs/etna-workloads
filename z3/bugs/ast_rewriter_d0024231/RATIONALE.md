# Rationale
All changes are in src/src/ast/rewriter/bool_rewriter.cpp, undoing the FIX.diff hunks:

1. mk_nflat_and_core: removed the `neg_lits.reset(); pos_lits.reset();` added after the loop (FIX hunk 3). Marks stay set until the destructor, as before the fix.
2. mk_nflat_or_core: removed the `neg_lits.reset(); pos_lits.reset();` added after the loop (FIX hunk 4), and removed the reset that the fix moved away from just before local_ctx_simp (FIX hunk 5). The mark1/mark2 flags therefore stay set while local_ctx_simp (which uses the same marks) runs, so the mark-owner assertion fires (ast.h:519) on 3342.smt2.
The hunk-2 change (is_not(arg, atom)) is behaviour-neutral and left alone.

A plain reversal (reset only inside the local_ctx branch) did not fail; deleting that reset makes the bug show.

## Final ./check.sh output
BUILD OK
FAIL z3test:smt2/3342.smt2 (rc=110)
    1c1,5
    < unsat
    ---
    > ASSERTION VIOLATION
    > File: <z3-src>/src/ast/ast.h
    > Line: 519
    > m_mark2_owner == 0 || m_mark2_owner == owner
    > (C)ontinue, (A)bort, (S)top, (T)hrow exception, Invoke (G)DB, Invoke (L)LDB
