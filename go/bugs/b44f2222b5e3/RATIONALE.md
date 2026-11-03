# Rationale

Fix reversed: types2/infer.go (go/types counterpart is not present in src/cmd/compile).
The fix added, in the `core == nil` branch of the constraint-unification loop in `infer`,
a check that a known type argument tx has all of the constraint's methods (unifying
method signatures). In go1.27.3 this was merged into one step that runs independent of
core terms (`if tx != nil && !isParameterized(tparams, tx)`). I restored the pre-fix
behaviour by guarding that step with `core != nil`, so methods are not considered
(and type params in method signatures are not inferred) when no core type exists.

Failing oracle cases (types2): TestExamples/inference.go (wantsMethods no longer infers Q, R
or reports the expected "does not satisfy" errors), TestFixedbugs/issue51593.go
(`f[T]` can no longer infer R), plus issue60556, issue61685, issue66751 which rely on the same inference.
