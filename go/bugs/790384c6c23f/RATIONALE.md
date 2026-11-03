# Rationale

Fix hunk reversed: the `src/cmd/compile/internal/types2/decl.go` hunk in `typeDecl`. It added the check that an alias RHS must not be a type parameter declared in the same declaration (go.dev/issue/75884, 75885).

In go1.27.3 the alias branch of `typeDecl` still has the check, just with different surrounding code (no `unalias(alias)` call and no `else` block). I removed the check block after `alias.fromRHS = rhs`. That restores the pre-fix behaviour, where no check at all was made for a type parameter on the alias RHS, so `type A[P any] = P` is accepted.

The fix's `go/types` hunk is not applied, because the task only covers `src/cmd/compile`.

Oracle result: `TestFixedbugs/issue75885.go` fails, and so does the parent `TestFixedbugs`. The expected error "cannot use type parameter declared in alias declaration as RHS" is no longer reported.
