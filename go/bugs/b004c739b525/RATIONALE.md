# Rationale

The fix (enableArgSorting = true) made inference order independent for named vs unnamed
argument types. In go1.27.3 the argument-sorting code is gone; order independence for #43056
is provided by the unifier (unify.go, "select the defined type", citing go.dev/issue/43056).

Change: src/cmd/compile/internal/types2/unify.go, in `nify`, the `case yn:` branch
(x unnamed, y defined) no longer calls `u.set(px, y)`. The first-seen (possibly unnamed)
type stays inferred, so the result depends on argument order again, as before the fix.

Oracle failures: TestFixedbugs/issue43056.go (f(j, i), g(j, i) now rejected), TestExamples/functions.go
(g3 case), plus issue51139, issue60933, issue62157 which rely on the same selection.
