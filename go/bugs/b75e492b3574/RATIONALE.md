# Rationale

Single file changed: `tree/src/cmd/compile/internal/types2/decl.go`, `collectMethods`.

1. Fix hunk "delay checkFieldUniqueness via check.later" (reversed): removed the
   `check.later(... checkFieldUniqueness(base))` call and restored the pre-fix
   eager loop that calls `base.Underlying()` and inserts every non-blank struct
   field into `mset` during method collection. This forces early expansion of the
   underlying type before `base` is fully set up (#52529). `checkFieldUniqueness`
   stays as now-unused code (a method, so it compiles).
2. Fix hunk "drop the *Var case in the duplicate-method error switch" (reversed):
   because fields are again in `mset`, a method clashing with a field is reported
   at the method as "field and method with the same name" and skipped, as before.

Oracle: `TestFixedbugs/issue52529.go` (Foo[P]{_ *Bar[P]}; type Bar[Q] Foo[Q];
method on *Bar[R]) now crashes the types2 test binary (panic during Check), which
also fails the many oracle cases that run after it in that process.
