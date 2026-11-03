# Rationale

Fix hunk: `mayModifyPkgVar` gained `case ir.OINLCALL: return true`, so an inlined call
makes `seenMutation` true and stops staticopy of later `var b = x`.

On go1.27.3 that case is absent, but the `ir.Any` walk descends into the InlinedCallExpr
body, finds the `x++` OASOP on a package var, and returns true. So reversing the hunk is a no-op.

Change (src/cmd/compile/internal/staticinit/sched.go, `mayModifyPkgVar`): replaced `ir.Any`
with an equivalent explicit recursive walk (`ir.DoChildren`) that treats OINLCALL as a leaf
returning false, so inlined bodies are not examined. This restores the pre-fix state where an
inlined call was not recognised as possibly modifying globals.

Oracle: test/fixedbugs/issue66585.go fails. `var a = foo(); var b = x` is rewritten to
`b = 0` so main panics with "unexpected b value" (b is 0, not 1).
