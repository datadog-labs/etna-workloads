# Rationale

Fix: `defer/go t.M(uintptr(ptr))` — method calls were not rewritten to `T.M(t, ...)`
before the go/defer wrapper was built (wrapCall), so the unsafe.Pointer->uintptr
arguments were not hoisted/kept alive (issue 44415 / 24491a).

In go1.27.3 the method call is rewritten earlier (typecheck.FixMethodCall in tcCall),
so the walk-level hunks (`rewriteMethodCall` in walkCall1 / wrapCall) have no direct
equivalent. The wrapper is now built by `normalizeGoDeferCall`
(src/cmd/compile/internal/typecheck/stmt.go). The change there restores the pre-fix
behaviour for method calls only: the uintptr(unsafe.Pointer) hoisting
(`visit(&arg.X)` for OCONVNOP) is skipped when the callee is a method expression
(a rewritten method call), so those args are converted inside the wrapper and the
pointer is not kept alive/escaped from the go/defer statement, exactly like direct
calls got in CL 253457 but method calls lacked before the fix.

Oracle: test/fixedbugs/issue24491a.go fails with `panic: method call: p failed`
(the new "method call" case added by the fix). TestShouldTest passes.
