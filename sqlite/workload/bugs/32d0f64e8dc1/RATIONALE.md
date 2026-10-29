# Rationale

Fix (ticket fd76310a5e): added `sqlite3Isspace(zNew[0])` to the syntactic check in `isLikeOrGlob()` (src/whereexpr.c) that
disables the LIKE optimization when the LHS is not a TEXT column and the prefix might look numeric.

In 3.54.1 that syntactic check was replaced (2019-06-14) by a `sqlite3AtoF()` test on the prefix (and prefix+1), which
implicitly handles leading whitespace. I restored the pre-fix check: in the `if( pLeft->op!=TK_COLUMN || affinity!=TEXT || virtual )`
block, `isNum` is now `isdigit(zNew[0]) || '-' || '+' || zNew[iTo-1]=='0'-1`, with no whitespace case, which is the
state before the fix. The `rDummy` variable and the AtoF calls are removed.

Oracle: like-16.1 and like-16.2 fail. With `a INTEGER COLLATE NOCASE` and `a LIKE ' 1%'`, the prefix ' 1' is applied
with numeric affinity as a range constraint (a>=' 1' AND a<' 2'), so the rows ' 1x' and ' 1-' are wrongly excluded.
