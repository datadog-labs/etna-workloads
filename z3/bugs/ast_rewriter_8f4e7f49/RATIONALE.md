Changed hunks (all in src/src/ast/rewriter/seq_rewriter.cpp, mk_seq_replace), tracing to the mk_seq_replace hunk of FIX.diff:
1. Dropped the `str().is_string(c, s3)` guard on the "a' contains b" string rewrite. The old code only checked b, so when c is not a literal, s3 stays empty and replace is rewritten incorrectly.
2. Removed the new "a := b + rest -> c + rest" rule (`m_lhs.get(0) == b`) that the fix added.
The for_each_expr.cpp hunk is already present in today's code, and the CTRACE hunk is cosmetic, so I did not touch either.
With the changes, z3test:smt2/2533.smt2 gives "sat" plus "invalid model" instead of "unsat".
Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/2533.smt2 (rc=1)
    < unsat
    > sat
    > (error "line 19 column 10: an invalid model was generated")
