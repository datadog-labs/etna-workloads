# Rationale

Fix hunk reversed: in `types2/unify.go` `nify`, the fix removed the up-front
`x = Unalias(x); y = Unalias(y)` and compared `Unalias(x) == Unalias(y)` instead,
so alias names are kept (xorig/yorig) until the switch.

Change: restored the two up-front `Unalias` assignments at the top of `nify`
(before the `x == y` check). Inference then loses alias information: `f(a)`
with `type A = int` infers `int` instead of `A`. The other fix hunks
(asBoundTypeParam Unalias, xorig/yorig) are left as-is; they are harmless once
x and y are pre-unaliased. (go/types is outside src/cmd/compile, untouched.)

Failing oracle cases: TestFixedbugs/issue67628.go (error reports `int` rather
than `A`), TestExamples/inference.go, and their parents.
