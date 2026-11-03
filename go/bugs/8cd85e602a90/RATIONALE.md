# Rationale (issue 74473, loopbce.go)

Reverses all implementation hunks of fix.patch in `src/cmd/compile/internal/ssa/loopbce.go`:
- `parseIndVar` no longer returns the `loopReturn` edge (hunk 1; doc line removed too).
- `findIndVar` no longer computes `startBody` via dominance of the loop-return edge, and no longer handles the
  `if x {exit} else {body}` form (hunks 2-3). It assumes `b.Succs[0]` is the loop body again
  (`startBody := b.Succs[0]`, kept as a variable because go1.27.3's later code uses it; equivalent to the pre-fix `b.Succs[0]`).
  The later checks and `entry:` already use `startBody`, so they act on `b.Succs[0]` as before the fix.

Oracle: `test/prove.go` fails: for `issue74473` (`if i >= len(s) { break }`) the loop body is Succs[1], so the
induction variable is not recognised: missing "Induction variable: limits [0,?), increment 1" and "Proved IsInBounds".
