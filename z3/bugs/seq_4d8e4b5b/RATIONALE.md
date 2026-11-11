# Rationale

Changed hunk (src/src/ast/rewriter/seq_rewriter.cpp, seq_rewriter::reduce_by_length):
removed the `&& has_var(rs)` / `&& has_var(ls)` guards on the two `len1 == len2 && len1 > 0` branches.
Traces to the FIX.diff hunk `@@ -5896,14 +5902,14 @@` which added those guards (and has_var itself).
Without the guard, equalities with equal fixed lengths and no variable side (e.g. "B" = replace("B","",substr("A",0,a)))
are rewritten again and again into new equations instead of being left alone, so the solver never terminates / is killed (rc=137) on 6052.smt2.

The other FIX.diff hunks were not reverted (not needed to reproduce the failure). has_var is left defined but unused.

Final ./check.sh output:
FAIL z3test:smt2/6052.smt2 (rc=137)
1d0
< sat
