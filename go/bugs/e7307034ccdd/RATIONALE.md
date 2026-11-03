# Rationale

The fix generalised the amd64 8-byte byte-store combine rule to use
`sequentialAddresses(...)`, and added `if x == y && n == 0 { return true }` to
`sequentialAddresses` so identical pointers count as sequential. In go1.27.3
the byte-store rule is gone (replaced by the generic `memcombine` pass), but
the `sequentialAddresses` hunk still applies and is still relied on by the
`MOVQstoreconst` -> `MOVOstoreconst` zero-merging rules in `_gen/AMD64.rules`.

## Change
`src/cmd/compile/internal/ssa/rewrite.go`: removed the `x == y && n == 0`
early return from `sequentialAddresses`. This reverses the fix's rewrite.go
hunk exactly. With the shortcut gone, two stores through the same pointer
value are no longer recognised as sequential (the remaining cases only match
LEAQ1/ADDQ-based addresses), so adjacent stores are not combined.

## Oracle
`Test/codegen/memcombine.go` fails (amd64/v4): the zeroing of two adjacent
8-byte stores at line 883 emits `MOVQ $0,(AX)` / `MOVQ $0,8(AX)` instead of a
single `MOVUPS`. This is a missed store combine, the same kind of failure the
fix's `store_le64_idx2` test guards against. `TestShouldTest` still passes.
The original byte-store rule and `store_le64_idx2` case are not reproduced
because that mechanism no longer exists.
