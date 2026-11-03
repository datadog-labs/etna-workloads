# Rationale

Fix: types2 `missingMethod` must type-check a wrong-name method (`check.objDecl(f, nil)`) before `funcString` formats it.

In go1.27.3 the fix's hunk (in the fold-case lookup) is gone; the same guarantee is given by a single
`if cause != nil { if f != nil { check.objDecl(f) } }` block just before the `switch state`
in `src/cmd/compile/internal/types2/lookup.go`. The per-case objDecl at the "we must have a method" step
only runs when the method was found by exact name, not for wrongName.
Change: removed that block. A wrong-name method `f` (found by case folding) is then never type-checked
before `funcString(f, false)`, so its signature may be unset -> crash. Equivalent to the pre-fix behaviour.

Oracle: `TestFixedbugs/issue59848.go` (and the parent TestFixedbugs) fail with a panic in types2 Check
(`var _ I = T{}` with `func (T) m()` declared after use). Many other cases listed as failing because the panic aborts the package test run.
