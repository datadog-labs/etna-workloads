# Rationale

Changed: `src/cmd/compile/internal/typecheck/stmt.go`, `tcSelect`'s `oselrecv2` closure.
Removed `selrecv.SetInit(n.Init())`, reversing the fix's typecheck hunk. The new OSELRECV2
node is again built without the original OAS node's Init (the `x := <-ch` DCL), so it is dropped.

The fix's `transformSelect` hunk (noder/transform.go) has no counterpart in go1.27.3: that
function no longer exists (the unified IR frontend replaced it), so nothing to revert there.

Oracle: `Test/fixedbugs/issue48289.go` fails with `panic: got *ptr 1, want 0`. The per-iteration
`x` loses its declaration, so `&x` aliases one variable across iterations. `TestShouldTest` still passes.
