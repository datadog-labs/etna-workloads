# Rationale

Changed hunk: `seq_rewriter::mk_re_range` in src/src/ast/rewriter/seq_rewriter.cpp.
Traces to the FIX.diff hunk `@@ -4126,30 +4159,42 @@` (mk_re_range). I undid it: a bound that is not a
concrete single-character literal again sets `is_empty = true`, so `(re.range x x)` with symbolic x
collapses to `re.empty` (the unsound behaviour). The early BR_FAILED for symbolic bounds is removed.

The other FIX.diff hunk (mk_str_in_regexp reduction) was left alone. It is the added feature, and
with mk_re_range collapsing first, the range never reaches it. seq_rewriter test 15 sees `false` rather than a conjunction.

## Final ./check.sh output (tail)
    range inter disjoint: re.none
    range inter touching: (str.to_re "f")
    range union overlapping: (re.range "a" "k")
    range union adjacent: (re.range "a" "k")
    range union disjoint (stays as union): (re.union (re.range "a" "c") (re.range "m" "z"))
    star of empty range: (str.to_re "")
    concat absorbs empty range: re.none
    union absorbs empty range: R!0
    inter absorbs empty range: re.none
    symbolic range (x in [x,x]): false
    ASSERTION VIOLATION
    File: <z3-src>/src/test/seq_rewriter.cpp
    Line: 588
    Failed to verify: m.is_and(e)
    
