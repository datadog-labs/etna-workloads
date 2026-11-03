# Rationale

## Changed hunk
`src/cmd/compile/internal/staticinit/sched.go`, the `assign` closure in `StaticAssign`.

This reverses the fix's `assign` helper hunk. That hunk added the `ir.IsBlank(a)` special case, which uses `ir.BlankNode` as the LHS instead of a `NameOffsetExpr` (#43677). I removed the special case, so the closure always builds `ir.NewNameOffsetExpr(pos, a, aoff, v.Type())`. That matches the pre-fix behaviour, where dynamic initialisation of a blank global went through `NameOffsetExpr`.

The fix's other hunks are already in go1.27.3 and I left them alone:
- `NewNameOffsetExpr` still has its blank-name check, so the pre-fix misuse now reports as an ICE. The check was added by the same fix.
- The call sites already use the `assign` helper.

## Oracle result
`test/fixedbugs/issue43677.go` fails with: `internal compiler error: cannot take offset of nil, blank name or non-global variable: _`. This is the same ICE the issue describes. `TestShouldTest` passes, so one of the two oracle cases fails.
