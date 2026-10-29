Reproducer: repro.sql (case tkt-2a5629202f-1.3).
A table has a nullable column b with a UNIQUE index on b; two rows have b NULL.
`ORDER BY b, c` uses the index and wrongly skips the sort for c, since NULLs are
not distinct in a unique index.
Clean: null/four, null/three, a/one, b/two. Buggy: null/three, null/four, a/one, b/two.
