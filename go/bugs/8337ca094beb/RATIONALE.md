# Rationale

Fix reversed: go.dev/issue/59956 (rename type parameters of generic function arguments, e.g. `f(g, g)`).

## Change: src/cmd/compile/internal/types2/call.go, `Checker.arguments`
The fix hunk replaced `tparams = append(tparams, asig.TypeParams().list()...)` (plus a TODO) with a call to
`check.renameTParams` and storing the renamed signature in the argument. In go1.27.3 that block also has
`asig = clone(asig)` (added later for #63260); it exists only to protect the object's type from the renaming
mutation, so with no renaming it is dropped too. The block is restored to the pre-fix form: the generic
argument's original type parameters are appended to `tparams`, with the original TODO comment.
Code for partial targs and padding `targs` is unchanged.
The go/types copy is generated from types2 and is outside src/cmd/compile, so it is untouched.

## Oracle failures
`./check.sh`: 6 of 592 fail: TestInstanceInfo/issue59956 (and parent), TestFixedbugs/issue59956.go (and parent),
TestExamples/inference2.go (and parent). With `f(g, g, g)` all arguments share one type parameter P,
so inference fails with a mismatch (e.g. "type func[P any](P) of g does not match func(string)").
