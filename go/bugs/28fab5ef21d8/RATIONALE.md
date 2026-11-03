# Rationale

Fix (#51527) disabled constraint type inference of missing type arguments for
type instances (`enableTypeTypeInference = false` in `instantiatedType`).
In go1.27.3 that inference code was already deleted, so the pre-fix behaviour
is restored in `src/cmd/compile/internal/types2/typexpr.go` (`instantiatedType`):
before the instance is created, if `len(targs) < len(tparams)`, call
`check.infer` and use the inferred list when it is longer. This is the
equivalent of the pre-fix `if len(targs) < len(tparams) { check.infer(...) }`
in the resolver (the resolver no longer exists). Only types2 is changed
(go/types is outside src/cmd/compile).

## Oracle failures
- test/typeparam/issue51232.go and issue51233.go (errorcheck): `Fn[RCT]` with
  one of two type arguments now compiles instead of reporting
  "got 1 arguments", so "compilation succeeded unexpectedly".
- types2 TestCheck cases for typeinference.go / fixedbugs expecting the
  "got N arguments" errors also fail.
