# Rationale

Fix hunk reversed: `absFunc` in src/func.c (integer case). The fix added an
"integer overflow" error for abs(-9223372036854775808). In 3.54.1 that check is
`if( iVal==SMALLEST_INT64 )`; I removed it and restored the pre-fix
`if( iVal<0 ) iVal = iVal * -1;`, so abs(SMALLEST_INT64) silently wraps to
-9223372036854775808.

Not reverted: the float `-rVal` change and the random() 64-bit change (no
observable bug), and the test4.c hunk (test-only).

Oracle failure: func-18.32 (`SELECT abs(-9223372036854775807-1)` expected
`1 {integer overflow}`) fails; func-18.31 still passes.
