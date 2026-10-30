# Rationale

## Changed hunk: `fixedpoint_d2string` in `tree/src/util.c`
Reverses the fix's second implementation hunk. The fix replaced the loop
`for (i = integer_digits + 1; i < fractional_digits; i++) dst[i] = '0';`
with `memset(dst + integer_digits + 1, '0', fractional_digits)`. That loop was
wrong (its bound compares an absolute index with the digit count and starts
at the wrong offset), so for small values such as 0.0001 the zero padding
is skipped and junk already in the buffer is left in the output. The 9.0.7
code still has the memset, so I put the old loop back.

Not changed: the first hunk (the `dvalue == 0` case). The old loop there was
correct, so reverting it would not bring back the bug.

## Oracle failure
`GEOSEARCH with small distance` fails. GEORADIUS ... WITHDIST returns
`0.00 1` instead of `0.0001`, which is the junk-in-buffer symptom. The other
72 cases pass. The fix's C unit-test additions are in src/util.c's
test code, which is not part of this oracle.
