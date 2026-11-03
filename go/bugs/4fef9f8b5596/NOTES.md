repro.go declares a grouped local type declaration `type ( A = int; B = []A )` and uses B.
Clean toolchain: compiles and prints 1. Buggy toolchain: types2 leaves A on the object path
(the pop is deferred rather than done per iteration), so it reports a bogus
"invalid recursive type A" (A refers to B, B refers to A) and a follow-on assignment error.
