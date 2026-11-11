# Rationale
Single hunk in src/src/ast/rewriter/seq_rewriter.cpp (mk_seq_extract): removed the block
"For integer n >= 0, c*n^k >= n ..." that rewrites substr(a, c*len(a)^k, _) to the empty string.
This is the sole implementation hunk of FIX.diff (the code had since renamed variables, so the diff
doesn't reverse-apply). Without it the extract is not simplified, reintroducing the bug (#11157):
the out-of-range offset isn't recognised and regex unfolding is needed.

Final ./check.sh output:
BUILD OK
FAIL seq_rewriter (rc=114)
    ASSERTION VIOLATION
    File: src/src/test/seq_rewriter.cpp  Line: 165
    Failed to verify: extracted == empty
