# Rationale

Hunk changed: `src/cmd/compile/internal/noder/reader.go`, `finishWrapperFunc`.
It reverses the fix hunk that switched `ir.VisitList(fn.Body, ...)` to `ir.VisitFuncAndClosures(fn, ...)`.
The comment added by the fix is removed too. The scan for `OMETHVALUE` nodes after inlining
goes back to covering only the wrapper's own body, not the bodies of closures inside it.
The `ir.VisitFuncAndClosures` helper in `ir/visit.go` stays, because `inlheur` now uses it.

Oracle result: `test/fixedbugs/issue60945.go` fails with
`internal compiler error: missing wrapper for a.m`. This is the bug from #60945.
`TestShouldTest` passes.
