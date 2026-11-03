repro.go is the issue79265 testdata case: `type _ A; type A = T; type T [unsafe.Sizeof(A{})]int`.
Clean go reports "invalid recursive type A" (A refers to T, T refers to A).
Buggy go's isComplete doesn't walk aliases, so it calls Underlying on an incomplete alias and the compiler
panics with a nil pointer dereference (internal compiler error).
