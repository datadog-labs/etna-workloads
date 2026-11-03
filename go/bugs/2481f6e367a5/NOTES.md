Reproducer: repro.go (test/typeparam/issue48253.go). It calls a method of a generic type promoted through embedded generic fields (Foo{}.Bat(), where Foo embeds A[string], which embeds B[int]).

Clean toolchain: runs and exits 0. Buggy toolchain: internal compiler error ("index out of range [0] with length 0"), exit 1. The injected code uses the base receiver's type params instead of the instantiated type arguments for embedded-field method calls.
