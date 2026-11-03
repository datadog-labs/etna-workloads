# Rationale

## src/cmd/compile/internal/ssa/prove.go (simplifyBlock, OpMul case)
Reverses the fix hunk: `isUnsignedPowerOfTwo(xl.umin)` / `(yl.umin)` go back to
`isPowerOfTwo(int64(xl.umin))` / `(int64(yl.umin))`. In go1.27.3 the helper is
generic and `isUnsignedPowerOfTwo` no longer exists, but the pre-fix expression is the
same: casting a uint64 limit to int64 makes 1<<63 negative, so it is not seen as a power of two.

## Oracle
test/prove.go (Test/prove.go) fails: for `issue76688` (x>1 || y != 1<<63 guard, then x*y),
the multiply is now rewritten into a CondSelect instead of being left for a shift
("Rewrote Mul v21 into CondSelect; v7 is bool" reported as unmatched, since the test
expects no such rewrite).
