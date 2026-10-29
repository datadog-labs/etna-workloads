# Rationale

Changes are all in `tree/src/whereexpr.c`; each reverses a hunk of fix.patch.

1. `exprAnalyze()` (LIKE/GLOB upper-bound computation): restored the old
   `u8 c, *pC; c = *pC; ... *pC = c + 1;` form. This removes the loop that
   carries over trailing 0xBF bytes (set to 0x80, move to the previous byte)
   before incrementing, and the `assert(*pC!=0xFF)`. A prefix whose last UTF-8
   byte is 0xBF (e.g. U+307F = E3 81 BF) now gets 0xC0 as its last byte, which
   is an invalid upper bound (should be E3 82 80).
2. `isLikeOrGlob()`: restored the old condition
   `sqlite3Utf8Read(&z2)==0xfffd || ENC(db)==SQLITE_UTF16LE`, dropping the
   explicit `c==0xff` bad-utf-8 check (the comment text was left as is).

## Oracle failure
`like3-7.1` (the second one, `word GLOB 'み*'` on a UTF-16be database with an
index) fails: the index range `word>='み' AND word<'<bad bound>'` omits the row.
The like3-8.* cases still pass in this tree (Utf8Read apparently already
maps 0xFF to 0xfffd), so hunk 2 alone is not observable.
