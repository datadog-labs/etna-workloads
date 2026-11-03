repro.go instantiates a generic alias (`type A[_ any] = any`) with too many type arguments in a type-parameter constraint.
Clean: `too many type arguments for type A: have 2, want 1`.
Buggy: the compiler also prints "The following panic happened checking types near: ./repro.go:5:6", and the message names the alias as `main.A[_ any]` instead of `A`.
