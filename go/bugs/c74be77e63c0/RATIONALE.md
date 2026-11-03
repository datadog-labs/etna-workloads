# Rationale

Fix (issue 50281) changed `allString(x.typ)` to `structuralString(x.typ)` being a string, so that
`append([]byte, s...)` accepts a type parameter constrained by `string | []byte`, not only pure-string type sets.

go1.27.3 implements this in `types2/builtins.go` (`_Append`) by iterating `typeset(y.typ())`
and accepting `[]byte` or string members (at least one string). I removed the `[]byte` member
branch, so any type set containing `[]byte` falls to `y = nil` and the special case is rejected. Only pure-string
type sets are accepted, which is the pre-fix `allString` behaviour.

Oracle failures: `test/typeparam/issue376214.go` (`append(*buf, s...)` with `S ~string | ~[]byte` is rejected:
"cannot assign string (in Bytes) to []byte"). The std library (`encoding/json/jsontext`) uses the same pattern,
so the build fails and every types2 oracle case fails too.
