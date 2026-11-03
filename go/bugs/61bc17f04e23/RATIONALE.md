# Rationale

## Changed hunk
`src/cmd/compile/internal/ssagen/ssa.go`, `case ir.OSPTR`: for slices, always emit
`ssa.OpSlicePtr` (assumed non-nil) instead of choosing `OpSlicePtrUnchecked` when the node
is not `Bounded()`. This reverses the fix's ssa.go hunk exactly. The fix's other hunks
(the `Bounded` comment in ir/node.go and `SetBounded(true)` in walk/convert.go and walk/range.go)
are harmless without this one and were left alone. `OpSlicePtrUnchecked` and its rules still exist, so no
other code was touched.

## Oracle
`test/fixedbugs/issue59293.go` fails: `unsafe.SliceData(nil)` goes through `OpSlicePtr`, which
nilcheck treats as non-nil, so `f(nil)` reports a non-nil pointer and panics with "bad f".
