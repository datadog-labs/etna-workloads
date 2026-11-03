# Rationale

Hunk changed: `src/cmd/compile/internal/types2/infer.go` (the `infer` function, method-unification step).

The fix turned the `else { if tx != nil {...} }` branch (method unification only when the constraint has no core term) into an unconditional step guarded by `tx != nil && !isParameterized(tparams, tx)`. In go1.27.3 the block is already unconditional, so I re-added the old restriction by guarding it with `core == nil &&`. Methods of a known type argument are then unified against the constraint's methods only if the constraint has no core type, which is the pre-fix behaviour.

The go/types copy is not touched, since the task limits changes to src/cmd/compile.

Oracle failures: `TestFixedbugs/issue66751.go` (and its parent `TestFixedbugs`). Inference no longer finds the remaining type arguments for `f[*S]`, `withBoth[*fooer[int]]()` and `CallM2(X{})`, because those constraints have both a core type and methods. Type-checking reports the errors that the fix removed.
