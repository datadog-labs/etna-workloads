# Rationale

Fix (2005-08-28): isLikeOrGlob() gained a check that the LHS column's collating
sequence matches the LIKE flavor (BINARY for case-sensitive, NOCASE for
case-insensitive); otherwise the LIKE optimization is rejected. Before the fix
the optimization ignored collations and used any index on the column.

In 3.54.1 that check no longer exists as such: the range terms derived from LIKE
(`x>=lo AND x<hi`) are explicitly tagged `COLLATE NOCASE` / `COLLATE BINARY`
(`zCollSeqName` in src/whereexpr.c, exprAnalyze), so an index is usable only if
its collation matches. This is the modern equivalent of the removed check.

## Change (src/whereexpr.c, exprAnalyze LIKE block)
Removed `zCollSeqName` and the `sqlite3ExprAddCollateString()` wrappers on the
two derived terms. The terms now take the column's own collation, so the
LIKE range is applied through any index regardless of whether its collation
suits the LIKE flavor -- the pre-fix behavior (collations ignored).

## Oracle failures (test/like.test)
21 cases fail, including like-5.1/5.2 (binary index used for case-insensitive
LIKE / wrong like_count), like-5.5..5.8 (NOCASE index with case-sensitive LIKE
or GLOB, wrong plan/results), like-3.13/3.14, like-5.11..5.18, like-11.x, like-12.x.
