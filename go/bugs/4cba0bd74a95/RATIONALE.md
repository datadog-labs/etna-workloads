# Rationale

Fix hunk: `panicAtUnificationDepthLimit = true` -> `false` (go.dev/issue/59740). The fix
only silenced the panic that fires when unification recurses without making progress.
In go1.27.3 the flag is already `true`, but the runaway recursion no longer occurs because
`nify` (types2/unify.go) forces `exact` mode for element types in assignment mode
(`emode |= exact` when `mode&assign != 0`).

Change: in `nify`, `emode := mode` only (dropped the `emode |= exact` branch). Element
types are again unified inexactly, so `F[int]`-vs-`func(F[T])` keeps peeling named types to
their underlying types forever, hits `unificationDepthLimit`, and the still-enabled
`panicAtUnificationDepthLimit` panics ("unification reached recursion depth limit"),
which is the pre-fix behaviour.

Failing oracle: TestFixedbugs/issue59740.go (the fix's test; panic instead of the expected
"does not match" errors), plus many other cases in the same package, since the panic
aborts the test binary.
