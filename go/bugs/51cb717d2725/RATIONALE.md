# Rationale

Fix hunk reversed: `types2/call.go` (`Checker.arguments`) — removed the `asig = clone(asig)` call
(and its comment) before the type-parameter renaming of generic function arguments. The renaming
then again operates on the signature that is pointer-identical to the generic function object's type,
so `asig.tparams = ...` / `arg.typ_ = asig` implicitly modify the object's type (go.dev/issues/63260).
The `clone` helper in predicates.go and the go/types copy are untouched (go/types is outside src/cmd/compile; clone stays as unused helper).

Failing oracle case: `TestIssue63260` (types2) — type of `v` in `f`'s body is no longer pointer-identical to f's type parameter T.
