# Rationale

The fix changed `rewriteArgument` in escape/call.go so that, for `Key:Value` elements of a slice
literal argument, only the Value is visited. In go1.27.3 that logic moved to
`normalizeGoDeferCall` in `src/cmd/compile/internal/typecheck/stmt.go`, which wraps go/defer calls.
(The `rewriteArgument` in escape/call.go already unwraps OKEY and is unrelated to the failing path.)

Hunk changed: in `visit`, case `OARRAYLIT/OSLICELIT/OSTRUCTLIT`, I removed the `*ir.KeyExpr` case
(`visit(&el.Value)`). A `KeyExpr` element now goes to the default case and `visit(&list[i])` treats
the whole `Key:Value` node as an operand, which is the pre-fix behaviour. The `StructKeyExpr` case
is untouched.

Oracle: `test/fixedbugs/issue49240.go` (`go copy([]int{1: 0}, []int{})`) fails with
`internal compiler error: TempAt called with nil type`, because the KeyExpr node has no type.
