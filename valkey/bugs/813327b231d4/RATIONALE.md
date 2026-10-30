# Rationale

Fix: `createQuicklistObject` gained `fill`/`compress` params, and SORT passed the
server config. Before the fix, SORT used `quicklistCreate()` defaults (fill=-2, compress=0)
and never called `quicklistSetOptions`.

In 9.0.7 the other callers (rdb.c, t_list.c) already set options correctly and
`createQuicklistObject(fill, compress)` exists, so only the sort.c hunks are reverted:

- sort.c, `sobj = createQuicklistObject(...)` (STORE path): reverses the sort.c STORE hunk;
  `(-2, 0)` equals the `quicklistCreate()` defaults used pre-fix.
- sort.c, `sortval = createQuicklistObject(...)`: reverses the matching sort.c hunk, same defaults.

## Oracle failure
`SORT STORE quicklist with the right options` in tests/unit/sort.tcl fails: the stored list has
`ql_listpack_max:-2 ql_compressed:0` instead of `-1` / compressed. The other 57 cases pass.
