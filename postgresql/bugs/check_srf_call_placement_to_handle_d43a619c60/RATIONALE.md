# Rationale

File: src/backend/parser/parse_func.c, function check_srf_call_placement().
Traces to the parse_func.c hunk of fix.patch. The fix made EXPR_KIND_VALUES (multi-row VALUES) reject SRFs
(nodeValuesscan.c can't handle them) and made EXPR_KIND_VALUES_SINGLE set p_hasTargetSRFs.
The reverse: both kinds are "okay" and p_hasTargetSRFs is not set. A SRF in multi-row VALUES is
accepted and reaches the executor/planner, and single-row INSERT VALUES SRFs are not processed as a tlist.
(The enum and other switch hunks of the fix are already consistent and need no change.)

Failing oracle case: src/test/regress||tsrf
