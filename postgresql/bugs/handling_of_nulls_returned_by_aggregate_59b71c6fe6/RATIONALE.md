# Rationale

The fix added a check in advance_combine_function() (nodeAgg.c) so a strict combinefn is not called with a NULL transValue. That function has since been replaced by expression-compiled steps. The equivalent guard is now `likely(!pergroup->transValueIsNull)` in the four strict-transition opcodes of `ExecInterpExpr` (src/backend/executor/execExprInterp.c):
EEOP_AGG_PLAIN_TRANS_INIT_STRICT_BYVAL, EEOP_AGG_PLAIN_TRANS_STRICT_BYVAL, EEOP_AGG_PLAIN_TRANS_INIT_STRICT_BYREF and EEOP_AGG_PLAIN_TRANS_STRICT_BYREF.

These opcodes also run combine functions. This change removes the guard from all four, which corresponds to the single hunk in fix_impl.patch. If a strict combinefn returned NULL on one cycle, the next cycle calls it again with a NULL state. It no longer propagates the NULL to the end.

Failing oracle case: src/test/regress||aggregates
