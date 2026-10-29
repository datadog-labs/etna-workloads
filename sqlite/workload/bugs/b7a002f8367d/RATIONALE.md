# Rationale

Fix hunks reversed (both in `isLikeOrGlob()`, src/whereexpr.c):

1. Fix hunk that added the check after the prefix is unescaped (using `zNew[0]`,
   including the `'/%'` case). In 3.54.1 that code is a generalized check
   (`sqlite3AtoF` on the prefix and on the incremented prefix, i.e. both range
   bounds). I removed it, so the escape-stripped prefix and upper bound are no
   longer examined.
2. Fix hunk that removed the original check at the top of `if( z ){`. I restored it:
   if the raw RHS `z[0]` is a digit or '-', and the LHS is not a TEXT-affinity
   ordinary column (or is virtual), return 0. It tests the raw pattern, so a
   leading escape character hides the digit/'-', and the '/%' pattern (upper
   bound '0') is not caught.

Oracle failures: like3-5.100, 5.101, 5.120-5.123, 5.200, 5.201, 5.300, 5.400,
5.410. For example, `x LIKE '/%'` on an INT-affinity column gets the range
constraint `x<'0'` converted to numeric, giving wrong results, and the
`'^12%' ESCAPE '^'` queries use the index instead of a scan.
