# Rationale

Reverted hunk: types2/stmt.go `typeSwitchStmt` (fix hunk "check rhs", which removed
`if x.mode == invalid { return }`). In go1.27.3 the code was already restructured
(`x.isValid()`, scoped block), so I re-added the early return: if the switch
expression is invalid, `typeSwitchStmt` returns before checking the case clauses.
The case bodies are then never type-checked, so imports used only there are
reported as unused. The `T = sx.typ()` hunk is already handled via `caseTypes(sx, ...)` in
the current code and needed no change. go/types is generated from types2 / not under src/cmd/compile, so untouched.

Failing oracle cases: TestFixedbugs and TestFixedbugs/issue67962.go (types2) -
the spurious `"fmt" imported and not used` error / missing "not an interface" checks
that the fix's test guards against.
