# Rationale

Bug (#40746): phioptint created `OpCvtBoolToUint8` values typed as the bool
input (`a.Type`) instead of uint8. Prove's `isNonNegative` then saw a
non-integer-typed value and panicked ("isNonNegative bad type") on
`int8(c) < 0`.

Changes:
1. `ssa/phiopt.go` (phioptint): reverses fix hunk 1; the Cvt value is typed
   `a.Type` (bool) again instead of `Types.UInt8`.
2. `ssa/prove.go` (`factsTable.isNonNegative`): in go1.27.3 prove's
   `isNonNegative` was rewritten to read `ft.limits` and lost the
   `!v.Type.IsInteger()` check that fix hunk 2 touched (panic -> Fatalf).
   Without the check, change 1 alone doesn't fail (bool values get limits
   [0,1]). I restored the pre-fix check (`panic("isNonNegative bad type")`)
   in that function, so the same defect is reachable the same way.

Oracle: test/fixedbugs/issue40746.go (both cases) fails: the compiler panics
in prove (`addValueFact` -> `isNonNegative`) while compiling `f`.
