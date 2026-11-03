# Rationale

Fix reversed: the "1 variables" / "1 values" pluralisation fix in the assignment
mismatch errors (Fixes #43348 cleanup; hunks in typecheck/stmt.go `assign`, which
introduced `plural(n)`).

In go1.27.3 that logic lives in `src/cmd/compile/internal/types2/assignments.go`,
function `measure`, which `assignError` uses to build "assignment mismatch: N
variable(s) but M value(s)". The change drops the `if x != 1` check so the unit is
always pluralised, restoring the pre-fix output ("1 variables", "1 values").
Side effect: `measure` is also used in signature.go for the type-parameter count message.

Oracle cases failing: test/fixedbugs/issue27595.go, issue30087.go, used.go
(expected "1 variable but ..." / "1 value", got "1 variables"/"1 values").
