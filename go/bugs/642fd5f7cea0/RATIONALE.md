# Rationale

Fix hunk (types2/typeset.go, intersectTermLists): replaced `Comparable(t.typ)`
with strict comparability `comparable(t.typ, false, nil, nil)`.
(go/types hunk has no counterpart in this tree's scope.)

In go1.27.3 the strict check is `comparableType(t.typ, false, nil) == nil`
(typeset.go:334). I restored the pre-fix call `Comparable(t.typ)`, which is
`comparableType(T, true, nil) == nil` (dynamic/spec comparability), so
interface-containing types like `[2]any` survive intersection with `comparable`.

Failing oracle cases (types2): TestFixedbugs/issue57486.go (the fix's test:
the expected "does not implement" errors are not reported), TestFixedbugs
(parent), and TestFixedbugs/issue57500.go.
