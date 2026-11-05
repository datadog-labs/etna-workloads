# Rationale

File: src/backend/utils/adt/rangetypes.c, function daterange_canonical().

Traces to the fix_impl.patch hunk in the same function. The fix added `!DATE_NOT_FINITE(...)` guards to both the lower-bound check (exclusive lower -> +1, inclusive) and the upper-bound check (inclusive upper -> +1, exclusive). I removed both guards in the current code, which uses `DateADT bnd` with an overflow check.

Effect: an infinite date bound is incremented by one. That gives a wrong value or a spurious "date out of range" error, instead of leaving infinity untouched.

Failing oracle case: src/test/regress||rangetypes
