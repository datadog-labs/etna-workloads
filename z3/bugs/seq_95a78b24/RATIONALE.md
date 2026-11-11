# Rationale
One hunk in src/src/ast/rewriter/seq_rewriter.cpp, `seq_rewriter::mk_seq_suffix`: traces to the FIX.diff hunk
`@@ -1431,69 +1543,7 @@ br_status seq_rewriter::mk_seq_suffix`, which removed the constant-string suffix shortcut
(isc1/isc2 block). I re-added it. When both sides end in string constants of equal length it returns false
even if the constants are equal, so `(str.suffixof "B" (str.++ s "B"))` is rewritten to false, which gives an invalid model on 4044.smt2.
(Adapted to today's API: str(), data(); `a1/a2/a3` declarations reused by the later replace check.)

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/4044.smt2 (rc=1)
    1a2
    > (error "line 3 column 10: an invalid model was generated")
