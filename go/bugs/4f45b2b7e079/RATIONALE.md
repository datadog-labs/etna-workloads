# Rationale

Fix (CL 654195, #72063) added a check in `canInlineCallExpr` (inline/inl.go) that refuses
inlining when the caller or callee body contains a call whose `Fun` is also one of its own
arguments. That hunk is already absent from go1.27.3 (the code was restructured), but the case is
covered by a second path: the position-based recursion check that follows `inlineCostOK`.

Change: removed that check in `canInlineCallExpr` (`parsePos(n.Pos(), ...)` plus the loop
comparing each inlining-stack position's line/col/file with the innermost call position and
returning false, "recursive call to ..."). This is the same defect: with the Y-combinator
closure, `f(h(h))(t)` keeps re-inlining the same call site through closures. `parsePos` is
left in place, now unused (legal in Go).

Result: compiling test/fixedbugs/issue72063.go no longer terminates. `./check.sh` ran past its
10-minute limit and was killed while the compiler was still inlining. Before the change the
oracle passed (0 of 2 cases failing). The failure is a hang/memory blowup, matching the
"out of memory when inlining closure" bug. I did not see check.sh print a per-case result.
