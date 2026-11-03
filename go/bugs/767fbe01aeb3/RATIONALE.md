# Rationale

Fix hunk: `noder/writer.go` `maybeTypeAndValue` looked up `Info.Instances[name]` to
override `tv.Type`, because types2 recorded the *generic* signature in `Info.Types`
for functions implicitly instantiated from assignment context.

In go1.27.3 that writer hunk is still present, but it is redundant: `Info.Types` already
holds the instantiated type. So reverting the writer hunk alone does not bring the bug back
(check.sh: 0 failures). This is the "fixed twice" case, so both paths are reverted.

1. `noder/writer.go`: removed the `Info.Instances` lookup in `maybeTypeAndValue`
   (exact reversal of the fix hunk; `typeAndValue` already uses `maybeTypeAndValue`).
2. `types2/expr.go` `rawExpr`: when `nonGeneric` implicitly instantiates x via reverse
   inference (assignment context), record the original generic signature in `Info.Types`
   (the pre-instantiation behaviour), leaving the instance only in `Info.Instances`. The
   operand keeps the instantiated type, so type checking is unchanged.

## Oracle failure
`test/fixedbugs/issue59338.go` fails: `internal compiler error: func[P any](x P) P is not
assignable to func(int) int`, at `g3(g1, 3)`, the cases the fix re-enabled.
