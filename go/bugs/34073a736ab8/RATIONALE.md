# Rationale

Fix (issue 71680) added `isClosureParent` checks to `canInlineCallExpr` in
`inline/inl.go`, to stop a closure and its parent inlining each other forever.
On go1.27.3 those checks are not present at all, yet issue71680.go compiles.
The loop is stopped by the older position-based recursion check in the same
function, which looks for the call's own position in the inlining stack
(`parsePos` / "recursive call to ..."), so the fix's hunk can't be reversed.

## Change
`src/cmd/compile/internal/inline/inl.go`: removed the `parsePos(n.Pos(), ...)`
loop in `canInlineCallExpr`, which returned `false` for "recursive call to
<callerfn>". This is the other path covering the same case, the same defect
(infinite parent -> closure -> parent inlining). Without it, and without the
fix's closure-parent checks, the inliner has no guard.

## Oracle
`test/fixedbugs/issue71680.go` (compile test): the compiler no longer
terminates (infinite inlining loop, killed by timeout). The std library still
builds (checked `go build -a net/http`), so only the recursive closure case
hangs. `parsePos` is left in place, now unused.
