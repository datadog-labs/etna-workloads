# Rationale

Fix (issue 58341): go/defer wrapping must evaluate the RType of builtins
(delete, append, copy, ...) up front, so the wrapper closure captures a temp
instead of referring to the outer function's `.dict` param.

In go1.27.3 the wrapping lives in `typecheck.normalizeGoDeferCall`
(src/cmd/compile/internal/typecheck/stmt.go), not escape analysis; the
equivalent of the fix's `argumentRType(&call.RType)` calls is `visit(&call.RType)`.

Changes (typecheck/stmt.go):
- OAPPEND/ODELETE/OPRINT/OPRINTLN/ORECOVER case: removed `visit(&call.RType)`
  (reverses the argumentRType hunks for append and delete/print).
- OCOPY case: removed `visit(&call.RType)` (reverses the copy hunk).

Result: RType stays a reference to the outer `.dict` inside the wrapper.

Oracle: test/fixedbugs/issue58341.go fails with
`internal compiler error: 'S[go.shape.int].M1.deferwrap1': value .dict (nil) incorrectly live at entry`
(the liveness error the fix addressed). TestShouldTest passes.
