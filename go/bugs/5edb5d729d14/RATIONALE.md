# Rationale

go1.27.3 already contains the fix (`v.step`, `indVarCountDown` removal was already done).
Only the overflow guard was reverted, in `src/cmd/compile/internal/ssa/downward_counting_loop.go`:

- Removed the `neededRoom` computation and the `switch check.Op { ... safeAdd(start.AuxInt, neededRoom, ...) ... }` block
  (plus the now-unused `fmt` import). This reverses the fix hunk that added them. Without it, loops are inverted even when
  `i-step` on the final iteration would wrap around `start`, so the inverted comparison `start < i-step` can stay true.
  The `step` field in `indVar` is left in place (unused), harmless.

Oracle: `issue78303_1.go` fails with `panic: got wrong result` (loop runs past end, a(3) is called).
`issue78303_2.go` still passes (the down-counting variant is not miscompiled in this tree).
