# Rationale

Changed `src/cmd/compile/internal/walk/convert.go`, `walkCheckPtrArithmetic`: removed
`slice.SetEsc(ir.EscNone)` on the `...` slice built for the `checkptrArithmetic` call.

This reverses the fix hunk that marked the ... argument (`ddd.Esc = EscNone`) as non-escaping.
In go1.27.3 the slice is built by `typecheck.MakeDotArgs`, which has no `ddd` node, so
the equivalent is setting Esc on the composite literal directly. Without it the backing array
is heap-allocated (complit.go only stack-allocates for EscNone), so every checkptr-instrumented
unsafe pointer arithmetic allocates.

Oracle: `Test/fixedbugs/issue36516.go` fails with
"too many allocations; want 0 got 2.000000".
