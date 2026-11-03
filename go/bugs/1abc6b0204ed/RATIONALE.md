# Rationale

Fix: go/types, types2: permit type cycles through type parameter lists (#68162).
The fix added, before the final `check.cycleError` in `validCycle`, an early
`return true` when `tparCycle` is set.

In go1.27.3 the same early return lives earlier in `validCycle`
(src/cmd/compile/internal/types2/decl.go, right after the trace block). I
removed it. A cycle through a type parameter list (which `break loop`s with
ndef == 0, nval == 0) then falls through to `check.cycleError`, as before the
fix. go/types is outside src/cmd/compile and was not touched.

## Failing oracle cases
Recursive constraints like `type I[T I[T]] interface{ F() T }` are rejected
again with "invalid recursive type: I refers to itself":
- test/typeparam/issue48280.go
- test/typeparam/issue48306.go
(plus other cases accepted only after the fix, e.g. issue46461, issue68162).
