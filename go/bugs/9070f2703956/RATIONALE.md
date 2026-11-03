# Rationale

Fix: types2 `infer.go` passed `check.allowVersion(..., go1_21)` to `newUnifier`, so interface inference (shared methods) was disabled for `-lang` < go1.21.

Change: `src/cmd/compile/internal/types2/infer.go`, `newUnifier(check, tparams, targs, check.allowVersion(go1_21))` -> `newUnifier(check, tparams, targs, true)`.
This reverses the fix's infer.go hunk. In go1.27.3 the unifier field `enableInterfaceInference` already exists, so the only pre-fix behaviour to restore is that it is unconditionally enabled (the old constant `true`).

Oracle failures: `TestFixedbugs/issue61903.go` (and parent `TestFixedbugs`) in types2. Under `-lang=go1.20`, `f2(t, s)` now infers via interface unification and no longer reports "type string of s does not match inferred type int for P".
