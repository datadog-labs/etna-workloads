# Rationale

Fix: attach the keepalive (OVARLIVE) to the call so SSA emits it right after the call, instead of at the end of the enclosing statement (order's cleanTemp).

In go1.27.3 the "attached to the call" mechanism is `CallExpr.KeepAlive`, filled by escape/call.go and emitted as OpVarLive right after the call in ssagen/ssa.go. The old end-of-statement mechanism (cleanTempNoPop) no longer exists, so I re-expressed it in `src/cmd/compile/internal/walk/order.go`:

- `orderState.call`: moves `n.KeepAlive` into `o.keepAlive` and clears it (reverses the hunk that attached the live markers to the call in order.go/ssa.go; ssagen therefore emits nothing after the call).
- `orderState.popTemp` / new `emitKeepAlive`: at the end of the statement (where the old cleanTempNoPop emitted VARLIVE), emits compiler `runtime.KeepAlive(&tmp)` calls (the current spelling of VARLIVE) into `o.out`. For `return f(uintptr(p))` this lands after the return, so it is dead and the pointer isn't kept alive during the call; with `before(...) + after()` the pointer stays alive until the end of the statement, i.e. too long.

Oracle: issue24491b fails (the object is kept alive across after(); the test deadlocks/never sees the finalizer). issue24491a fails too (the return-statement case).
