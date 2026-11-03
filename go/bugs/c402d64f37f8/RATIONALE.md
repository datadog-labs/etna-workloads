# Rationale

Hunk reversed: `types2/api.go` `Implements` (fix hunk), now in `api_predicates.go`.
The fix replaced the method-only check (`MissingMethod(V, T, true)`) with the
empty-interface shortcut, invalid-type handling, and `Checker.implements`
(which also checks type-set/structural restrictions). In go1.27.3 the function
has the same shape (using `isValid` and `implements(V, T, false, nil)`); I
restored the old body: `m, _ := MissingMethod(V, T, true); return m == nil`.

Failing oracle cases: `TestImplements` (types with `~int` constraints, empty
type sets, and invalid types are judged by methods only, so e.g.
`Implements(N1p, CI)` and `Implements(int, EmptyTypeSet)` return true).
`TestIssue50646` also fails, for the same reason.
