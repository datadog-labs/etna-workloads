# Rationale

Changed: `tree/src/cmd/compile/internal/types2/decl.go`, `constDecl`.

Removed the `if inherited { check.errpos = obj.pos }` block before `check.expr(nil, &x, init)`.
This reverses the fix hunk in `constDecl` that sets `check.errpos` for inherited initializers.
With `errpos` never set, `handleError` (the equivalent of the fix's `errors.go` hunk) no longer
rewrites positions, so errors in inherited const init expressions are reported at the original
expression's position instead of at the constant identifier, as before the fix (#42991, #42992).
The plumbing (`inherited` field/param, `errpos` field) is left in place but is inert.

## Oracle failures
`Test/fixedbugs/issue8183.go` (cmd/internal/testdir) fails: errors for `bard` and `e`/`f` are
reported at the original expression lines (12, 19) rather than at the const identifiers
(lines 15, 21, 22), giving "missing error" and "Unmatched Errors".
