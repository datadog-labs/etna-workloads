# Rationale

Fix (go.dev/issue/57155): type parameters were renamed during inference only for
"self-recursive" calls (`tparams[0] == check.sig.tparams.At(0)`); inside function
literals `check.sig` is clobbered, so the heuristic missed recursion. The fix renames always.

In go1.27.3 the renaming lives in `renameTParams` (infer.go), called from call.go
(`arguments` for the callee, and the explicit-instantiation path at ~line 108).

Changes:
- infer.go: new `renameCalleeTParams` wrapper that restores the removed `selfRecursive`
  condition and returns tparams/typ unchanged when not self-recursive (reverses the
  types2 infer.go hunk, which removed `if selfRecursive {...}`).
- call.go: the two callee-renaming sites (`check.renameTParams` -> `check.renameCalleeTParams`).
  The renaming of generic function *arguments* (issue 59956, a later, separate feature) is untouched.

Only types2 is changed (go/types is outside src/cmd/compile).

Oracle: TestFixedbugs/issue57155.go fails (the function-literal case `f(p, q)` inside `f`
is no longer renamed, so unification hits the cycle). The same run also panics/crashes the
test binary, so many later oracle cases in the package are reported failing too.
