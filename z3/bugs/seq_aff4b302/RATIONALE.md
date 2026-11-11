# Rationale
FIX.diff's functional hunk changes `seq_rewriter::get_lengths` from `return true;` to `return !pos.is_neg();`,
i.e. get_lengths refuses expressions whose constant offset is negative. (The other hunk only adds a TRACE.)
In this release get_lengths already ends in `return true;`, and the guard lives in its callers, so the fix is
undone by dropping those guards (the same effect as get_lengths accepting negative constants):
1. `extract_push_offset`: `get_lengths(b, lens, pos1) && pos1 >= 0` -> `get_lengths(b, lens, pos1)`.
2. `extract_push_length`: removed `&& !pos.is_neg()`.
3. `mk_seq_at`: removed `&& !r.is_neg()` in the `lens.contains(lhs)` test.
Effect: negative offsets such as len(s)-1 get cancelled against the concatenated term, so
at(s0, len(s0)-1) simplifies to empty, giving an invalid model for 2417.smt2.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/2417.smt2 (rc=1)
    1a2
    > (error "line 16 column 10: an invalid model was generated")
