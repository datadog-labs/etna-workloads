# Rationale

The fix reverted the MOVBE-for-GOAMD64>=v3 CL (#49061, make.bash broke with GOAMD64=v3).
go1.27.3 has MOVBE re-landed (ops, ssa.go cases, rules), so the whole revert can't be applied;
instead the re-landed rules in `ssa/_gen/AMD64.rules` (and regenerated `rewriteAMD64.go`) were
put back to the original CL's form:

1. `(BSWAP(Q|L) x:(MOV(Q|L)load ...))` and its MOVBE inverse: dropped the `@x.Block`
   result block, so the new load is created in the BSWAP's block (original CL form; this moves
   the load across other memory ops, the cause of the v3 build failure). Reverses the
   `+(BSWAP(Q|L) x:(MOV(Q|L)load ...)) => (MOVBE(Q|L)load ...)` rule hunk.
2. Dropped `buildcfg.GOAMD64 >= 3` from the MOV(Q|L)store<-BSWAP and BSWAP<-MOV(Q|L)load rules,
   so MOVBE is emitted regardless of GOAMD64 (this is what the fix's versions_test.go /
   memcombine.go hunks guard against: MOVBE must not appear for v1/v2). Same rule hunk.

## Oracle failures
- `test/codegen/memcombine.go`: at amd64/v2, expected BSWAPL/BSWAPQ not found, wrong MOV opcodes.
- `cmd/compile/internal/amd64` package test run also reports FAIL (see check.sh output).
