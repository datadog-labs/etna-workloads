# Rationale

Fix hunk reversed: `lockBtree()` in src/btree.c. The fix added `|| pageSize<512`
to the page-size validity check on page 1. Without it, a header page size that is
a power of two but below 512 (e.g. 256) is accepted.

In 3.54.1 the check is `((pageSize-1)&pageSize)!=0 || pageSize>SQLITE_MAX_PAGE_SIZE || pageSize<=256`.
I removed the `pageSize<=256` clause (the modern spelling of `pageSize<512`, since
valid sizes are powers of two). The later `usableSize<480` check is not reverted,
since it is a different check (the fix did not add it).

Result: the bogus size 256 gets through to `sqlite3PagerSetPagesize()`, which asserts
`pageSize>=512`.

Failing oracle cases: filefmt-1.7 (page size 256 header) hits that assertion
in `sqlite3PagerSetPagesize` and aborts the run, so filefmt-1.7 through 4.4 do not
complete (22 of 41 cases). select1 is unaffected (the parse.y hunk is a
destructor/no-op cleanup, not reintroduced).
