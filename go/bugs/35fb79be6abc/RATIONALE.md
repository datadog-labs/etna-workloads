# Rationale

Fix: go/types, types2 overlap test for union termlist (issue 51607). Only the types2 half exists in cmd/compile.

Changed file: src/cmd/compile/internal/types2/union.go (reverses the union.go hunks of fix.patch).

1. `parseUnion`: restored the per-case `continue` in the `switch` on interface terms (methods / comparable / embeds comparable), and removed the unconditional `continue` after the switch. Interface terms without those errors therefore fall through to the overlap test again.
2. `overlappingTerm`: removed `assert(!IsInterface(y.typ))` and the `if IsInterface(x.typ) { continue }` skip, and restored the old comments. Interface-typed terms are again passed to `term.disjoint`.

Together these give the pre-fix behaviour: syntactic interface terms are mixed with normalized type-set terms in the overlap test, so e.g. `interface{union|union}` or `T1 | T1` reports a bogus "overlapping terms".

Oracle failures (check.sh): TestExamples, TestExamples/constraints.go (`union|int`, `union|union` now error), TestFixedbugs, TestFixedbugs/issue51607.go.
