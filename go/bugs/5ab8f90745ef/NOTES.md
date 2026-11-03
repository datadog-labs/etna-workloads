repro.go converts values whose type is a local alias (`type A = P1`, `type A = *S`) to a
type with identical underlying type (tags ignored / pointer base types).
Clean: compiles and prints "ok". Buggy: types2 convertibleTo doesn't Unalias, so compile
fails with "cannot convert p ... to type P2" / "to type *T" (exit 1).
