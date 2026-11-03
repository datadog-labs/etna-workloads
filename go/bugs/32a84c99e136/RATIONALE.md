# Rationale

Changed: `src/cmd/compile/internal/liveness/plive.go`, `epilogue()`: removed the
`if n.OpenDeferSlot() { livedefer.Set(i); ... Needzero check }` block.

Reverses the fix hunk in `epilogue()` that added exactly this block (marking all
open-coded defer arg slots live everywhere, and thereby in the `deferreturn` stack
map, `livenessMap.DeferReturn`, built from `livedefer`). The other fix hunks
(LivenessMap.deferreturn, LastDeferExit removal, etc.) are still in go1.27.3 in
renamed form and are the plumbing the block feeds; without the block, the
deferreturn map no longer contains the defer arg slots, as before the fix
(where the map came from a return point that may not exist or may be unreachable).

## Oracle
`test/fixedbugs/issue40629.go` fails: the deferreturn stack map omits the first
defer's `&x` argument, so it is not adjusted on stack copy; the recovered defer
sees a stale pointer to the old stack and the test crashes/panics
("corrupted stack variable" / fatal runtime error).
