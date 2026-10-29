# Rationale

## Change: tree/src/expr.c, sqlite3ExprListDup()

This reverses the fix's core hunk in `sqlite3ExprListDup()`. The fix changed
the allocation of the duplicated `ExprList` from an exact-size allocation
(`sizeof(*pNew)+sizeof(pNew->a[0])*(p->nExpr-1)`) to
`sqlite3DbMallocRawNN(db, sqlite3DbMallocSize(db, p))`, i.e. an allocation
whose size matches the *actual* heap block size of the original list (which
may be larger than strictly needed, since `sqlite3ExprListAppend()` grows
lists geometrically, by power-of-two `nAlloc` steps).

In 3.54.1 the `ExprList` struct carries an explicit `nAlloc` field tracking
how many `a[]` slots are actually allocated, and `sqlite3ExprListDup()`
copies `nAlloc` from the source list into the duplicate as well as `nExpr`.
By restoring the pre-fix exact-size allocation while still copying
`pNew->nAlloc = p->nAlloc`, the duplicate's declared capacity (`nAlloc`) is
now larger than its real allocation, which only has room for `nExpr` slots.
`sqlite3ExprListAppend()` consults `nAlloc` to decide whether to grow before
writing a new slot (`if( pList->nAlloc<pList->nExpr+1 )`); when the dup's
`nAlloc` lies about the usable space, the writer skips reallocation and
writes past the end of the buffer — the same out-of-bounds write the
original bug caused, just mediated through the modern `nAlloc` bookkeeping
instead of the old `bFixedSize` power-of-two assumption.

The code reverted:
```
-  pNew = sqlite3DbMallocRawNN(db, sqlite3DbMallocSize(db, p));
+  pNew = sqlite3DbMallocRawNN(db,
+             sizeof(*pNew)+sizeof(pNew->a[0])*(p->nExpr-1) );
```
directly undoes the allocation-size hunk of the fix (the central hunk in
`src/expr.c`).

The fix's other hunks — the `VVA_ONLY(pNew->bFixedSize = 1)` /
`VVA_ONLY(pList->bFixedSize = 0)` assignments, the
`assert( pList==0 || pList->bFixedSize==0 )` guard in
`sqlite3ExprListAppend()`, and the removal of the `bFixedSize` field from
`struct ExprList` in `sqliteInt.h` — are debug-only instrumentation that
*detected* misuse of a dup'd list via assert() in SQLITE_DEBUG builds. They
are not reinstated because the mechanism they guarded no longer exists
(`bFixedSize` was a stand-in for "nExpr is not a power of two"; today's code
uses a real `nAlloc` counter instead). Reintroducing the field and its
asserts would at best make a debug build abort instead of corrupting memory,
which is not the historical release-build bug; the reverted allocation-size
hunk above is what reproduces the actual defect (a heap buffer overflow) in
3.54.1.

## Oracle result

Running `./check.sh` on `test/misc1.test` with this change applied, the new
regression case `misc1-26.0` added by the fix (which calls
`sqlite3ExprListDup()` indirectly via a subquery/`SELECT_COLUMN` expression
rewrite and then appends to the duplicated list) triggers heap corruption:
testfixture aborts partway through the suite with
`free(): invalid next size (fast)`, i.e. a crash consistent with the
out-of-bounds write the original bug caused. This happens before
`misc1-26.0` itself is reached in the printed per-case output, which is the
expected symptom for a heap overflow (corruption manifests later, on a
subsequent free/malloc, rather than as a clean test failure).
