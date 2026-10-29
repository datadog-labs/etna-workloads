# Rationale

## src/expr.c, codeInteger()
Reverses the fix hunk that added `|| (negFlag && value==SMALLEST_INT64)` to the
"oversized literal" condition (the old code had no such check; the fix also
added the sign to the "hex literal too big" message, which 3.54.1 already does
via `%s%#T`, so that part is left untouched).
In 3.54.1 the condition is now `(c==3 && !negFlag) || c==2 || (negFlag && value==SMALLEST_INT64)`;
I removed the last term. `-0x8000000000000000` (hex, which wraps to SMALLEST_INT64
with c==0) is then accepted as the integer -9223372036854775808 instead of
raising "hex literal too big".

## Oracle failure
test/hexlit.test hexlist-402: `SELECT DISTINCT -0x08000000000000000;` expected
`1 {hex literal too big: -0x08000000000000000}`, got `0 -9223372036854775808`.
