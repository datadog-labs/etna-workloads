# Rationale

Fix hunk (src/func.c, patternCompare): the "skip multiple wildcards" loop was changed
to `c == matchOne && matchOne!=0`, so that when `ESCAPE '_'` zeroes `matchOne`, a NUL
terminator (c==0) is not treated as a "_" wildcard.

Reverted in tree/src/func.c: the loop condition is back to
`(c=Utf8Read(zPattern)) == matchAll || c == matchOne`. The code is the same as the
pre-fix text; the surrounding code is unchanged in 3.54.1.

Oracle: like-17.1 fails (`SELECT 'x' LIKE '%' ESCAPE '_'` returns the wrong
result, since the end of the pattern is consumed as a matchOne and the string
character is eaten).
