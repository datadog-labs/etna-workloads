# Rationale (issue 79182)

Hunks reversed:
- `_gen/AMD64.rules` + `rewriteAMD64.go` (SHLQconst/SHLLconst): restored the unguarded
  `(SHL(Q|L)const [c] (ADD(Q|L) x x)) => (SHL(Q|L)const [c+1] x)`, dropping `c < 63` / `c < 31`.
  `(x+x)<<63` becomes `x<<64`, which the hardware masks to `x<<0`.
- Second path (`_gen/generic.rules` + `rewritegeneric.go`): in go1.27.3 the generic rule
  `(Add(64|32|16|8) x x) => (Lsh x 1)` rewrote x+x before lowering, and generic shift merging
  then folded the result to a constant 0, hiding the AMD64 bug. I removed that canonicalisation
  (and its comment) so `ADDQ x x` reaches the AMD64 rule, as before it existed.

Oracle: test/fixedbugs/issue79182.go fails: shl32(1)/shl64(1) return 1 instead of 0 ("FAIL" panic).
