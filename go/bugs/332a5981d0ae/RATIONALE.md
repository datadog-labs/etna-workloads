# Rationale

Fix (#54467): `assign` computes `mayOverlap` and `moveWhichMayOverlap` uses memmove/typedmemmove instead of OpMove for possibly partially overlapping array copies.

In go1.27.3 the logic lives in `src/cmd/compile/internal/ssagen/ssa.go` (`stmt`, OAS case). The fix's hunk computing `mayOverlap` and passing it to `assignWhichMayOverlap` is reversed by making `mayOverlap := false` (the pre-fix behaviour: no overlap consideration), removing the deref/string refinement. `moveWhichMayOverlap` is untouched, so it is never taken for assignments, and `*(*[32]byte)(y[4:36]) = *(*[32]byte)(y[2:34])` lowers to an OpMove that copies forward over overlapping memory.

Oracle: test/fixedbugs/issue54467.go fails (`x[20] = 18; y[20] = 16`, ...). nilptr5.go still passes.
