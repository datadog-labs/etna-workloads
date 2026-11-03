repro.go: calls generic `f[P ~A](P)` with `E` (underlying uint8) where `A = uint8` is an alias.
Clean toolchain compiles and prints "ok". Buggy toolchain (unifier lacks Unalias in the x == y early exit)
hits an internal compiler error: assertion failed at types2/unify.go:451.
