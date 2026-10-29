# Rationale

Fix (ticket #2211): when the ORDER BY is optimized away because an index/rowid
is unique, trailing ORDER BY terms must not reference other tables in the join
(`referencesOtherTables()` added to `isSortingIndex`/`sortableByRowid`).

In 3.54.1 that logic lives in `wherePathSatisfiesOrderBy()` (src/where.c), in
the block "Mark off any other ORDER BY terms that reference pLoop". Once a loop
is order-distinct, remaining terms are marked satisfied only if
`(mTerm & ~orderDistinctMask)==0`, i.e. they reference only tables that are
already order-distinct. That is the modern equivalent of
`referencesOtherTables()`. I removed this condition, so every remaining ORDER BY
term is treated as satisfied regardless of which tables it references,
which is the pre-fix behaviour (trailing terms ignored after a unique match).

Failing oracle cases: where-14.2 (`ORDER BY x.a, y.b DESC`) and where-14.7.1
(`ORDER BY x.b, y.a||y.b`-style) return rows in the wrong order / without sorting.
