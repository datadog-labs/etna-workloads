repro.go instantiates `Tb[P ~*Q, Q any]` with only one type argument (`Tb[*int]`).
Clean go1.27.3 rejects it ("not enough type arguments for type Tb: have 1, want 2", exit 1).
The buggy toolchain wrongly infers Q (type-type inference left enabled), compiles it and prints 0 (exit 0).
