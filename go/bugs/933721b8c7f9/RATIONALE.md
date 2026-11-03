# Rationale

File: `tree/src/cmd/compile/internal/ssagen/ssa.go` (the fix's `gc/ssa.go` code moved here; the logic is unchanged).

- `storeTypeScalars`, `case t.IsPtrShaped()`: removed the `t.IsPtr() && t.Elem().NotInHeap()` store. This reverses fix hunk 1. Pointers to `go:notinheap` types are no longer stored in the unconditional scalar part.
- `storeTypePtrs`, `case t.IsPtrShaped()`: removed the `break` for `NotInHeap` element types. This reverses fix hunk 2. The store goes back to being unconditional, as before the fix.

Both hunks are reverted to the pre-fix code. Pointers to `go:notinheap` types are represented as scalars, so the write-barrier-guarded pointer store no longer writes them. With the scalar-part store also gone, the pointer is never written.

## Oracle
`test/fixedbugs/issue42032.go` fails with `panic: pointer not written`. `append(a, T{&y,&z})` leaves the `*NIH` field nil. `TestShouldTest` passes.
