# Rationale

## Change: tree/src/func.c, patternCompare()

Fix hunk reversed: the fix changed the case-folding test to
`noCase && c<0x80 && c2<0x80 && sqlite3Tolower(c)==sqlite3Tolower(c2)`.
In 3.54.1 the same condition exists with the operands reordered
(`... && c<0x80 && c2<0x80` at the end), so the patch did not reverse
cleanly. I removed the `c<0x80 && c2<0x80` guard, restoring the pre-fix
`if( noCase && sqlite3Tolower(c)==sqlite3Tolower(c2) )`.

`sqlite3Tolower()` operates on a single byte (`(unsigned char)` index into
the lower-case map), so for code points >= 0x80 only the low 8 bits are used.
Different characters such as U+304D and U+306D, or U+304D and 'm' (0x6d),
are then wrongly treated as equal by LIKE.

## Oracle cases that fail

Run with `./check.sh`: like-13.1, like-13.2 and like-13.3 fail (LIKE returns 1
instead of 0). like-13.4 (`'M' LIKE 'm'`) still passes, as expected.
