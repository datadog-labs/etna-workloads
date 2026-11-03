# Rationale

Fix: go.dev/issue/69576 — type arguments of generic alias instances were not checked against constraints.

## Change
`src/cmd/compile/internal/types2/typexpr.go`, `instantiatedType`: re-added the pre-fix early return for aliases,
`if orig, _ := gtyp.(*Alias); orig != nil { return check.instance(...) }`, before the deferred `check.later`
closure. This reverses the fix hunk that removed that branch so aliases go through the shared `verify` path.
Alias instances thus skip `check.verify`, as before the fix. Today's code already has the `genericType`
plumbing from the fix, so only the early return needs to come back. (The fix's `res = check.newAliasInstance` hunk
in instantiate.go is already in place and is left as is; go/types is outside the allowed scope.)

## Oracle
`TestFixedbugs/issue69576.go` (and parent `TestFixedbugs`) in types2 fail: the expected error
"string does not satisfy int" for `A[string]` is not reported.
