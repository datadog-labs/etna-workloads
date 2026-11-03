# Rationale

The fix (#53982) lived in stencil.go (`buildClosure`), which no longer exists; with unified IR the same decision is made in `writer.methExpr` (src/cmd/compile/internal/noder/writer.go).

Fix hunk: derive type args from the actual receiver that has the promoted method (the embedded `x.T`), not the base receiver `x`.

Change: `methExpr` walks the embedded-field path (`typ`) to the type that has the method, then calls `w.methodExpr(expr, typ, sel)`. I reverted it to pass the base type `tv.Type` (the type in the method expression `(*S[K,V]).M`). `methodExpr` then computes the instantiation (`splitNamed`/`objInstIdx`) from `S[K,V]` instead of the embedded `E[V]`, which is the original wrong-typeparams bug.

Oracle: test/fixedbugs/issue53982.go fails with `internal compiler error: failed to find method M in shaped type S[go.shape.*uint8,go.shape.*uint8]`. TestShouldTest passes.
