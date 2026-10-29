# Rationale

Fix hunk (src/util.c, sqlite3DequoteNumber): the hex-prefix test was widened from
`zToken[1]=='x'` to `'x' || 'X'`.

In 3.54.1 the same test lives in `bHex` (tree/src/util.c:344), which drives both
the separator validation (xdigit vs digit) and the forced `TK_INTEGER`. I changed it back to
`pIn[0]=='0' && pIn[1]=='x'`, so `0X...` literals are no longer treated as hex.

Effect: `0XFF_FF` and `0XFF_EF` are validated as decimal, so the `_` next to `F`
is rejected with `unrecognized token`. (Without the fix, `0XFF_EF` would also be
mistaken for a float because of the `E`.)

Oracle failures: literal2-3.1.0 and literal2-3.1.1. The 0x cases and the error cases still pass.
