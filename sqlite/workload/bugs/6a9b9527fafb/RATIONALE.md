# Rationale

Fix: restore restriction (4) of push-down, which says the term can be pushed into the right operand of a LEFT JOIN only if it comes from that join's ON clause. Without it, a WHERE term was pushed into the right side of a LEFT JOIN.

In 3.54.1 the checks for restrictions (4) and (5) in `pushDownWhereTerms()` (select.c) are in a `#if 0` block. They now live in `sqlite3ExprIsSingleTableConstraint()` (expr.c), rules (4a)/(4b) and (5). That function is also used by where.c with `bAllowSubq==0`, and push-down is the only caller that passes `bAllowSubq==1`.

## Change (src/expr.c, sqlite3ExprIsSingleTableConstraint)
This reverses the fix hunk that added `isLeftJoin` and the `restriction (4)` check, plus the hunk that passed `isLeftJoin` from sqlite3Select.
For a LEFT JOIN right operand, rules (4a)/(4b) now apply only when `bAllowSubq==0` (the where.c callers). The push-down caller (`bAllowSubq==1`) keeps only the old restriction (5) test: reject a term from an ON clause belonging to a different join. Any other term, including a WHERE-clause term, is accepted. This is the pre-fix behaviour, where (4) was absent and only (5) remained.

## Oracle
`join2-7.0` fails. The view `test` with `WHERE c IS NULL` is pushed into the `LEFT JOIN (SELECT * FROM t2,t3)` subquery. This yields wrong rows instead of `3 4 {} {} {} x 5 6 {} {} {} x`. The other 60 cases pass.
