# Rationale

Fix (drh, 2008-12-12, ticket #3536) replaced OP_ForceInt + OP_MoveXX with
OP_SeekXX, which converts a real search key to an integer using ceiling()
for SeekLt/SeekGe and floor() for SeekLe/SeekGt (`if( pIn3->r > (double)iKey ) iKey++;`
/ `if( pIn3->r < (double)iKey ) iKey--;`), so rowid range bounds like
`rowid >= 4.9` hit boundary values correctly.

In 3.54.1 this logic lives in OP_SeekGE/GT/LE/LT in src/vdbe.c, as two
adjustments based on `sqlite3IntFloatCompare`. I removed the `else if( c<0 )`
branch (iKey smaller than the real key: `x >= 4.1` -> `x > 4`, `x < 4.1` -> `x <= 4`),
which is the "ceiling" half of the fix's real->int conversion
(SeekGe/SeekLt with key rounded down). Result: `rowid >= <real just above an integer>`
includes that integer, and `rowid < <real just above an integer>` excludes it.

Oracle: boundary1.test fails 2 cases (boundary1-2.65.ge.3, boundary1-2.65.lt.4),
wrong result sets for rowid comparisons against a real value at a boundary.
