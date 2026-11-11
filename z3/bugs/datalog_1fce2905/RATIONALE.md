Changes (all reintroduce the #3832 bug: rule inliner hits quantified rules):
1. dl_mk_rule_inliner.cpp (inline_tail): FIX.diff hunk replacing SASSERT(!has_quantifier(src)) with throw has_new_quantifier; restored the SASSERT.
2. dl_mk_rule_inliner.cpp (transform_rules): FIX.diff hunk that passes quantified rules through unchanged; restored SASSERT(!has_quantifier(*r.get())), so quantified rules trigger an assertion violation.
3. dl_mk_bit_blast.cpp: FIX.diff hunk returning BR_FAILED for interpreted (non-null family) functions; removed it.

Final check.sh output:
BUILD OK
FAIL z3test:smt2/3832.smt2 (rc=110)
