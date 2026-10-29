# Rationale

Fix hunk reversed: `src/where.c` `bestAutomaticIndex()` — "if( pSrc->isCorrelated ) return;".
In 3.54.1 the equivalent check is the `&& !pSrc->fg.isCorrelated` condition on the
automatic-index block in `whereLoopAddBtree()` (src/where.c). I removed that line, so
automatic indexes are again built on correlated sub-queries (materialized once and
reused, although their contents depend on the outer row).

The other fix hunks (the isCorrelated field, its computation in resolve.c, its copy in
SrcListDup) are left intact: they still exist and are used by select.c for other purposes.

Oracle failures: tkt-54844eea3f-1.1 (got `test-2 1 1 test-2 2 1 test-2 3 1`, expected `... 2 0 ... 3 0`)
and 1.2 (got `{} two {} two`, expected `{} two {} four`): stale automatic index reused across outer rows.
