# Rationale

Fix: `type C comparable` must be exported/handled like `type T error` (ErrorType/ComparableType analogy).
In go1.27.3 iexport/bexport are gone (unified IR); the equivalent special case for the
underlying interface of `comparable` lives in `noder/writer.go` `interfaceType`
(comment: "needed to handle type declarations like `type C comparable`").

## Change
`src/cmd/compile/internal/noder/writer.go`, `(*writer).interfaceType`: the special case that
re-exported comparable's underlying interface as `interface{ comparable }` (the analogue of the
fix's `underlying = types.ComparableType` in iexport.go doDecl) is replaced by an unsupported-case
failure. `type C comparable` therefore is again not handled and the compiler crashes.
(Simply deleting the branch silently turned C into `interface{}` and no oracle case failed, hence the explicit failure.)

## Oracle failures
- test/typeparam/issue47966.go (`type C comparable`): ICE "cannot write underlying interface of comparable".
- test/typeparam/subdict.go (`type C comparable; value[T C]`): same ICE.
