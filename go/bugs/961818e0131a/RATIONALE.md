# Rationale

Changed only `tree/src/cmd/compile/internal/walk/order.go`, in `addrTemp`.
The `ir/expr.go` hunk of the fix is a comment only, so it was not reversed.

1. Zero-value path: `ir.NewLinksymExpr(v.Pos(), ir.Syms.ZeroVal, n.Type())` is back to `v.Type()`.
   This reverses the fix's first order.go hunk. `v` comes from `staticValue(n)`, which can
   see through OCONVNOP, so `v.Type()` can differ from `n.Type()`.
2. Static composite literal path: `readonlystaticname(n.Type())` is back to `readonlystaticname(lit.Type())`.
   `lit` is `v`, so this is the same as the pre-fix `lit.Type()`. This reverses the second hunk.

Effect: the read-only temp is typed with the pre-conversion type (`SourceRange`) instead of
`testNode`. The linker then wrongly concludes `testNode`'s itab isn't used and prunes it, and
the call hits `runtime.unreachableMethod`.

Oracle cases that fail: `test/fixedbugs/issue73888.go` (zero value) and
`test/fixedbugs/issue73888b.go` (non-zero). Both crash at run time. Each is
triggered by its own hunk.
