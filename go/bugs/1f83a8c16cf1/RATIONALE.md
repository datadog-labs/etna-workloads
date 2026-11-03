# Rationale

Fix hunk: in `ssagen/ssa.go` (`state.expr`, OINDEX of a zero-length array) the fix replaced
`s.newValue0(ssa.OpUnknown, n.Type())` with `s.zeroVal(n.Type())`, so the result of an impossible
index is a real value when bounds checks are off (-B).

In go1.27.3 the code had been changed again: the `bound == 0` branch now returns
`s.load(n.Type(), s.constNil(n.Type().PtrTo()))`. I restored the pre-fix form in that branch:
`return s.newValue0(ssa.OpUnknown, n.Type())`. This is the same site and the same
"junk" result that the fix removed.

Oracle: `test/fixedbugs/issue48092.go` (`// compile -B`) fails with
`internal compiler error: '(*A).Get': not lowered: v13, Unknown UINT8`.
`TestShouldTest` passes.
