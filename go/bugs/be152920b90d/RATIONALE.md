# Rationale

Hunk changed: `src/cmd/compile/internal/staticinit/sched.go`, `tryStaticInit`.
Removed the `case ir.OAS2:` branch that the fix added (the code had since gained
an `OCONVIFACE` tweak in the loop; the whole case is removed). Without it, an
OAS2 node (`var a, b nat = f()` rewritten to use autotmps because types differ)
hits the `default:` case and triggers `base.FatalfAt` ("unexpected initialization
statement"), exactly the pre-fix ICE.

Oracle: `Test/fixedbugs/issue68264.go` fails with
`internal compiler error: unexpected initialization statement: a, b = .autotmp_0, .autotmp_1`.
