# Rationale

Changed `finishWrapperFunc` in `src/cmd/compile/internal/noder/reader.go`.

The fix added a pass after `InlineCalls(fn)` that visits the wrapper body and calls `wrapMethodValue` for any new `OMETHVALUE` nodes that inlining exposed. In go1.27.3 this is `ir.VisitFuncAndClosures(...)` after `interleaved.DevirtualizeAndInlineFunc`. It still has the same purpose, and the visit now also covers closures, which was added later. I removed that whole block, which restores the pre-fix behaviour.

Oracle: `test/fixedbugs/issue52128.go` fails with `internal compiler error: missing wrapper for M2`. `TestShouldTest` passes.
