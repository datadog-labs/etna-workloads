# Rationale

Fix (go/types, types2: correct alignment of atomic.Int64) added a special case in
`StdSizes.Alignof` so that the empty struct `sync/atomic.align64` has alignment 8.
In go1.27.3 the logic lives in two places in `src/cmd/compile/internal/types2`:
`gcsizes.go` (`gcSizes.Alignof`, used by `SizesFor("gc", arch)`) and `sizes.go`
(`StdSizes.Alignof`). I removed the `len(t.fields)==0 && IsSyncAtomicAlign64(T)` block
(returning 8) from both, restoring the pre-fix computation (alignment 1 for the empty struct).
The helper `IsSyncAtomicAlign64` is left in place (still exported/used elsewhere).

Oracle failures: `TestAtomicAlign` and `TestAtomicAlign/386` — on 386, atomic.Int64
gets offset 4 instead of 8 in `struct{x int32; y atomic.Int64; z int64}`, differing from the compiler.
