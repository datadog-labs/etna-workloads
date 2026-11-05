# Rationale

Changed file: src/backend/utils/adt/tsgistidx.c, functions `checkcondition_arr` and `checkcondition_bit`.

Traces to the tsgistidx.c hunks of fix_impl.patch. The fix made these GiST callbacks return `TS_MAYBE` instead of a definite "present" (formerly `true`). The GiST index is lossy: a hash or signature hit does not prove the lexeme is present. Today's code already evaluates NOT by default (the old `TS_EXEC_CALC_NOT` flag is now inverted into `TS_EXEC_SKIP_NOT`), so the old "cannot specify CALC_NOT" workaround has nothing left to reverse. I changed every `return TS_MAYBE` in the two callbacks back to `return TS_YES`. A lossy hit is again treated as a definite match. `!foo` then evaluates to NO on pages that only hash-collide with `foo`, so GiST scans wrongly skip matching rows.

Failing oracle case: src/test/regress||tsearch. `tstypes` still passes.
