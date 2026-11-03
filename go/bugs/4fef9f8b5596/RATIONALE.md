# Rationale

Reverses the types2 hunk of the fix (src/cmd/compile/internal/types2/decl.go, `declStmt`, `*syntax.TypeDecl` case):
`check.pop()` after `check.typeDecl(...)` is replaced by `defer check.pop()` placed before it.
In go1.27.3 the code was already the fixed form (apart from `typeDecl`'s signature), so this restores the pre-fix form directly.
Because declStmt loops over a group, the deferred pops don't run until the function returns, so grouped type declarations leave extra objects on the object path.
The go/types hunk is outside src/cmd/compile and was not changed.

Failing oracle cases: TestFixedbugs and TestFixedbugs/issue76366.go (`type ( A = int; B = []A )` inside a function).
