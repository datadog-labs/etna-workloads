# Rationale

go1.27.3 uses unified IR and no longer has stencil.go/transformCall. Generic interface
calls on shape types are kept alive via an R_USENAMEDMETHOD reloc emitted in
reflectdata.MarkUsedIfaceMethod, called from walkCall.

## Change: src/cmd/compile/internal/walk/expr.go (walkCall)
Reverses the fix's walk/expr.go hunk: for OCALLINTER whose receiver type HasShape(),
`reflectdata.MarkUsedIfaceMethod` is no longer called; the code relies on the dictionary
to mark the method used (the fix's comment), but nothing keeps the dictionary alive
(the KeepAlive part of the fix is absent). With inlining, the dictionary is unused, so the
method is deadcode-eliminated by the linker (issue 48047).

## Oracle
test/typeparam/issue48047.go fails: the binary crashes at runtime because
A[string].Work -> BImpl.Work was removed by linker deadcode. issue44688.go still passes
(it did not guard this behaviour in the current tree).
