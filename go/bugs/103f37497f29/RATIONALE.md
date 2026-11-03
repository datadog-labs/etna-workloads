# Rationale

The fix (issue 58300) added two things to `genssa` in `src/cmd/compile/internal/ssagen/ssa.go`. go1.27.3 still has both, so I removed both (one logical change):

1. Hunk 1/2 (`hasCall := false` and the `ACALL/ADUFFCOPY/ADUFFZERO` check): removed. It only fed the new block, so it is dead once that block is gone.
2. Hunk 3 (`if e.stksize == 0 && !hasCall { ... }`): removed. This block put a real nop, positioned at the function start, before the first instruction when that instruction came from an inlinee. In the current code it also skips `obj.ANOP`, which is a later tweak. Without the block, a frameless leaf function can start with an inlined instruction again.

## Oracle
`test/fixedbugs/issue58300.go` fails. `g` inlines `f` and has no frame and no calls, so its first instruction belongs to `f`. `name(g)` prints `main.f` instead of `main.g`.
`TestShouldTest` still passes, as expected.
