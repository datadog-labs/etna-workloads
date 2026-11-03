# Rationale

Fix: typecheck/const.go `evalunsafe` stripped implicit dot ops to find the right base selector for unsafe.Offsetof in instantiated generic functions. That code no longer exists in go1.27.3; Offsetof in generic code is handled by the unified IR (noder/writer.go `exprOffsetof`, which writes the full field index path from types2, and reader.go, which sums the offsets along it).

Change (src/cmd/compile/internal/noder/writer.go): the writer now keeps only the last element of the selection index, so the implicit (embedded) path is dropped and the offset is computed against the wrong base, as before the fix. Non-generic cases are constant-folded in types2 and are unaffected.

Oracle: test/fixedbugs/issue53137.go fails with `panic: offset mismatch`. Offsetof(d.B) yields B's offset inside Embedded (0) instead of Embedded's offset in S[K].
