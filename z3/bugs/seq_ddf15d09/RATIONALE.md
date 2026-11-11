# Rationale

Changed hunk: `src/src/ast/rewriter/seq_rewriter.cpp`, `seq_rewriter::mk_re_reverse`, concat case.
It traces to the FIX.diff hunk `@@ -2844,67 +2844,65 @@` in seq_rewriter.cpp, where
`result = re().mk_concat(a_rev, b_rev)` became `result = mk_re_append(a_rev, b_rev)`.
Today's code already has the other routing changes, so I reverted only this call to the raw
constructor. The reversed concatenation then skips the shared smart-constructor normalization,
for example `r . r{k} -> r{k+1}` and reassociation. This is the same bug the fix targets: derivative and
reversal construction bypassing regex normalization. The reversed form is no longer canonical.
`seq_regex_bisim` now fails at seq_regex_bisim.cpp:312 (`reverse(...) == twice` check).

Final ./check.sh output:
BUILD OK
PASS seq_monadic
FAIL seq_regex_bisim (rc=114)
    ASSERTION VIOLATION, File: src/src/test/seq_regex_bisim.cpp, Line: 312
    Failed to verify: rw.get_derive()(kind, ch_a, reversed) == twice
