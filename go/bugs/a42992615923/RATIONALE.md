# Rationale

Fix hunk (src/cmd/compile/internal/escape/escape.go, `location.leakTo`) added
`!sink.escapes` to the condition for recording a result leak. In go1.27.3 the
function lives in `escape/graph.go` and the field is the attribute
`sink.hasAttr(attrEscapes)`. I removed that term (and restored the old comment),
so a parameter flowing to a heap-allocated named result is again recorded as
"leak to result" instead of a heap leak.

## Oracle failure
`test/escape5.go` fails at `f(p *int) (r *int)` (issue 44614): the compiler
reports `leaking param: p to result r level=0` instead of `leaking param: p`,
so the expected `leaking param: p$` has no match.
