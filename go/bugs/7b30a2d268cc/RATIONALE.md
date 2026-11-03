# Rationale

Fix (isSmallMakeSlice): stack allocation of `make([]T, len, cap)` should depend only on cap being a small constant; pre-fix it also required len to be constant (`smallintconst(l) && smallintconst(r)`).
In go1.27.3 `isSmallMakeSlice` is gone; the equivalent check is `escape.HeapAllocReason` (src/cmd/compile/internal/escape/utils.go), which decides whether an OMAKESLICE is forced to the heap.

Change: in the OMAKESLICE branch, after the non-constant-cap hybrid path, added
`if !ir.IsSmallIntConst(n.Len) { return "non-constant size" }`, which restores the old requirement that len be constant too.
The walk-side panicmakeslicelen/cap checks (the other fix hunk) are still present and untouched; they were added to make the non-constant-len case safe, and the bug is the missed optimisation.

Oracle: test/escape_slice.go fails: `make([]int, i, 3)` and `make([]int, i, 1)` now "escape to heap" instead of "does not escape" (slice11).
test/fixedbugs/issue37975.go still passes: it guards panics, which are still emitted correctly (the fix's runtime behaviour is unchanged; only the escape/perf side regresses).
