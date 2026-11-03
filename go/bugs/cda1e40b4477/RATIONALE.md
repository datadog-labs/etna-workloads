# Rationale

Fix (issue 65778): in `doObj`, the RHS of a type alias was written as `w.typ(obj.Type())`
without `types2.Unalias`, so with gotypesalias=1 the alias's own `*types2.Alias` was written
as its RHS.

go1.27.3 has no `w.typ(obj.Type())` line: `doObj` now unwraps a materialized alias
itself (`rhs = alias.Rhs()`, with `tparams` taken from it). That unwrapping is the
equivalent of the fix's `Unalias`. I removed the `rhs = alias.Rhs()` line in
`src/cmd/compile/internal/noder/writer.go`, so `rhs` stays `obj.Type()`, the alias
itself, which is what the pre-fix code wrote. `tparams` is kept because that's newer,
unrelated functionality.

Result: running check.sh, both oracle cases (`Test/fixedbugs/issue65778.go`,
`TestShouldTest`) fail. The compiler crashes while compiling the test
(`type A = int; type T[P any] *A; var _ T[int]`) and the testdir run ends with
"[build failed]". I did not extract the crash's root frame from the output, so I haven't
confirmed it is the alias writing itself recursively, though that is the expected cause.
