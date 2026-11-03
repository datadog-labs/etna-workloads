# Rationale

Fix (golang commit 7c292ddf, #49536/#50552) removed the `todoBodiesDone` flag so that
function bodies of new functions discovered during nested inlining are queued
(and read, via `readBodies` in `InlineCall`) instead of being dropped.

Changes (all in src/cmd/compile/internal/noder):
- reader.go: re-added `var todoBodiesDone` and the `&& !todoBodiesDone` condition in
  `reader.addBody` (reverses hunks 1 and 2 of reader.go in the fix).
- unified.go: set `todoBodiesDone = true` after the main `readBodies(target, false, nil)`
  in `unified`/`readBodies` caller (reverses the removal of the flag set at the end of
  the old body-reading loop).

The `readBodies` call in `InlineCall` was left in place; with the flag set, `addBody`
no longer queues bodies for new declarations found while inlining, so it has nothing to read
(equivalent to its absence pre-fix).

Result: instantiated generic methods found during inlining never get bodies. The compiler
hits `assertion failed` (internal compiler error) when compiling std packages
(e.g. sync/atomic/type.go) and the oracle test issue49536 (both cases) fails with a build failure.
