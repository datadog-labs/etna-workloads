# Rationale

Fix (go.dev/issue/48962): validType must look through type arguments of instantiated types to detect invalid recursive types. Before the fix, `validType0` always replaced a named type with `t.orig` and so never saw type arguments (the fix added the tparamEnv / `*TypeParam` lookup).

## Change
`src/cmd/compile/internal/types2/validtype.go`, `*Named` case: add `t = t.Origin()` at the start.
This reverses the fix's removal of `t = t.orig` in `validType0`. In go1.27.3 the type-argument lookup is the `*TypeParam` case, which reads `TypeArgs()` of the innermost nest entry. Nest entries are now always origin types, which have no type arguments, so that lookup never matches. The result is the old behaviour: only uninstantiated types are considered, and recursion still terminates (e.g. `type A[T any] struct{ x A[*T] }`).

## Oracle failures
- `Test/typeparam/issue48962.go` (cmd/internal/testdir): b.go reports "missing error 'invalid recursive type'" on lines 18, 19, 25, 30, 31, 37, 39 and 49.
- The types2 package tests also fail (`FAIL cmd/compile/internal/types2`), covering the testdata files changed by the fix (issues.go2, typeinst, issue48962 etc.).
