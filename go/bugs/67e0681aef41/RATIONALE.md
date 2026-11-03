# Rationale

Hunk changed: `src/cmd/compile/internal/types2/range.go`. I removed the `for` loop that strips `*syntax.ParenExpr` from `rangeVar`. This reverses the fix's types2 hunk, and the code is still in the same place in go1.27.3.

`src/go/types/range.go` is not changed. It is outside src/cmd/compile, and the compiler doesn't use it.

Without the loop, the constant length for `range` over an array pointer is recorded on the ParenExpr. The unified IR writer expects it on the inner expression. For `for i := range (*p)` with `p` nil, the backend then evaluates `*p` and dereferences nil.

Oracle: `test/fixedbugs/issue73476.go` fails with a nil pointer dereference SIGSEGV. The expected output is 0 1 2 3. `TestShouldTest` passes.
