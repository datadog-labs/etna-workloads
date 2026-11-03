# Rationale

Fix hunk: in `assignWhichMayOverlap` (src/cmd/compile/internal/ssagen/ssa.go), the
`t.Size() == 0` case for assignment to an element of an ssa-able array added a
bounds check (`s.boundsCheck(i, len, ssa.BoundsIndex, false)`) before returning.

In go1.27.3 the same fix is present (with a comment referencing #79236, plus a
`_ = s.expr(left.X)` that was added later). I removed the comment, the `len`
constant and the `boundsCheck` call, leaving the early `return`, which is the
pre-fix behaviour: `a[i] = struct{}{}` on a zero-sized-element array never checks `i`.

Oracle: test/fixedbugs/issue79197.go fails with "a1: no panic (bug)"
(a1/a2/a3 no longer panic on out-of-range index 5).
