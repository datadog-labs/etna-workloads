repro.go is the issue65854 test program: an unparameterized alias `A = int` used in the RHS of a generic type `T[P any] *A`, then instantiated as `T[int]`.

Clean: compiles and prints "ok".
Buggy: types2 subst has no *Alias case, so substitution hits the default path and panics with "internal compiler error: panic: unreachable". The same panic also appears while building std packages (internal/abi, internal/runtime/atomic), so the build fails with exit status 1.
