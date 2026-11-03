# Rationale

Only the types2 hunk of the fix applies to go1.27.3 (src/cmd/compile/internal/types2/call.go, `genericExprList`); go/types is outside the allowed scope.

The fix introduced `infer := true` (for -lang < go1.21), set to false when `check.allowVersion(go1_21)`, and passed `infer` to `check.funcInst` in both the single-argument and multi-argument branches of `genericExprList`. I reverted this: the `infer` variable and its comment are removed, and both `funcInst` calls pass `false` again (as before the fix). The doc comment is also restored. With `-lang=go1.20`, partially instantiated function arguments such as `G(F[int])` therefore no longer get their missing type arguments inferred from constraints (`Q *P`).

## Oracle failures
`TestFixedbugs/issue60346.go` (and its parent `TestFixedbugs`) in cmd/compile/internal/types2 fail: 2 of 592 cases.
