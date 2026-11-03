# Rationale

Hunk changed: `src/cmd/compile/internal/types2/index.go`, `indexExpr`: removed `check.use(e.Index)` in the `!valid` ("cannot index %s") branch.
This reverses the types2 hunk of the fix. The index expression is no longer type-checked/used when the operand isn't indexable, so variables used only in the index are reported "declared and not used" (spurious error).
The go/types hunk is not applicable (go/types is outside src/cmd/compile/).

Oracle failures: `TestFixedbugs` and `TestFixedbugs/issue60906.go` (types2) fail with the spurious "declared and not used: x" error.
