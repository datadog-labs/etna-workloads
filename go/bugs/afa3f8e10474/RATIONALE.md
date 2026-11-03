# Rationale

Changed: `src/cmd/compile/internal/staticinit/sched.go`, `(*Schedule).staticcopy`.

Removed the `if s.seenMutation { ... return false }` block. This reverses the fix hunk that added that check in `staticcopy`, which stopped the static-copy optimisation once an earlier initializer might have modified a package variable. Without it, `var b = a` is again statically copied from `a`'s initializer even if an earlier initializer function reassigned `a`. This is the pre-fix behaviour.

`seenMutation` and `mayModifyPkgVar` are left in place. They are now unused for decisions, but the `-d=staticcopy` warning went away with the block.

## Oracle
`test/fixedbugs/issue51913.go` fails: `b` is statically initialised to `true`, although `a` is set to `false` by an earlier initializer, so the program panics with "FAIL". `TestShouldTest` still passes.
