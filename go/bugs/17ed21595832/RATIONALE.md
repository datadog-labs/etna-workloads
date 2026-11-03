# Reintroduced bug: go.dev/issue/71198 (panic instantiating generic alias with wrong type-arg count)

Changes (src/cmd/compile/internal/types2 only):

1. typexpr.go `instantiatedType`: reverses the typexpr.go hunk. Restores the unchecked
   `check.instance(...).(genericType)` assertion. `instance` can return Typ[Invalid] for
   an alias with the wrong number of type args, so the assertion panics.
2. instantiate.go `instance`, Alias case: reverses the instantiate.go hunk's
   `orig.obj.Name()` -> `orig.String()` (old error-message text) and the dropped comment.

Oracle: TestFixedbugs/issue71198.go fails (panic: interface conversion, Typ[Invalid]
is not genericType) for `func _[_ A[int, string]]()` with `type A[_ any] = any`.
The panic aborts the test binary, so many other cases in the package fail too.
