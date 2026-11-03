# Rationale

The fix reverted the rules that shortened `ANDQ`/`TESTQ` to `ANDL`/`TESTL` when the upper 32 bits are known zero. `TESTL` only sets flags from the low 32 bits, which is wrong when the flags feed a signed/ordered comparison.

Changes (the exact inverse of the fix hunks):
- `src/cmd/compile/internal/ssa/_gen/AMD64.rules`: re-added the two rules `(ANDQ x y)` and `(TESTQ x y)` after the `TESTB` const rule. They use the helper's current exported name, `ZeroUpper32Bits`; the old `zeroUpper32Bits` was renamed.
- `rewriteAMD64.go`: regenerated with `go run *.go` in `_gen`. This restores the matching code in `rewriteValueAMD64_OpAMD64ANDQ` and `rewriteValueAMD64_OpAMD64TESTQ`.

Oracle: `test/fixedbugs/issue62360.go` fails with `panic: b:-ffffffff c:ffffffff`. `big.NewInt(int64(uint32))` takes a wrong sign branch, as the ordered comparison used the TESTL flags. `TestShouldTest` still passes.
