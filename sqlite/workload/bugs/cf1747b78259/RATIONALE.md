# Rationale

Fix hunk: src/whereexpr.c `isLikeOrGlob` added `zNew[0]=='+'` to the list of pattern prefixes
(digit, '-', ...) for which a non-TEXT-affinity/NOCASE-collated LHS must disable the LIKE optimization.

In 3.54.1 that logic was rewritten: the prefix is tested with sqlite3AtoF, and if not numeric the last
character is incremented (upper bound) and tested again. For '+/' the upper bound '+0' is numeric, which
is what now covers the case. I restored the pre-fix gap by skipping that upper-bound test when the
prefix begins with '+' (`else if( zNew[0]!='+' )`). A '+' prefix is then no longer treated as
possibly-numeric unless it parses as a number itself, as before the fix.

Oracle: like3-5.300 fails (`c0 LIKE '+/'` on a REAL column with NOCASE index returns no row instead of `+/`).
