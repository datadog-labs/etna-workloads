# Rationale

Changed `src/cmd/compile/internal/types2/expr.go`, `Checker.nonGeneric`: `case *Alias, *Named:` -> `case *Named:`.
This reverses the fix's types2 hunk exactly (the fix still applied cleanly in go1.27.3's code). The go/types
hunk is outside src/cmd/compile and was not touched.

Effect: a generic alias (e.g. `type B[P any] = func()`) used without instantiation is no longer reported
("cannot use generic type B without instantiation").

Failing oracle cases: TestFixedbugs and TestFixedbugs/issue67683.go (expected errors for B and C are missing).
