# Rationale: issue 59174 (negative-size memclr inlined into a Zero)

## Hunk 1: `ssa/rewrite.go`, `isInlinableMemclr`
Reverses the fix hunk that added `if sz < 0 { return false }`. The guard is removed,
so the generic rule `(SelectN [0] call:(StaticCall {memclrNoHeapPointers} sptr (Const [c]) mem))`
turns a constant negative-size memclr into `Zero [c]` with c < 0, which no backend rule lowers.

## Hunk 2: `ssagen/ssa.go`, noreturn panic list in `stmt` (OCALLFUNC)
Removing the `isInlinableMemclr` guard alone does not bring the bug back on go1.27.3.
`panicmakeslicelen` is now treated as a noreturn call (it ends the block as `BlockExit`).
The `append(x, make([]T, n)...)` memclr code that `extendSlice` emits after the
`n >= 0` check is therefore dead and removed before the rewrite rules see it. Before, the
panic call fell through to the memclr. I removed `"panicmakeslicelen"` from that list,
which restores the old control flow, where the dead memclr with constant size -8 is still
visible to the rules. This is the same defect: the unreachable negative-size memclr is
only a problem because the memclr rule lacks the guard.

## Oracle result
`test/fixedbugs/issue59174.go` (`// compile`) fails with
`internal compiler error: 'p': not lowered: v146, Zero SSA PTR SSA`.
`TestShouldTest` still passes.
