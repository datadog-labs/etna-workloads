repro.go is the issue57155 test case (generic f[P *Q, Q any] calling itself inside a func literal), plus a main.

Clean toolchain: compiles and prints "ok".
Buggy toolchain: the compiler fails with "internal compiler error: panic: unification reached recursion depth limit" (exit 1).

Cause: the injection renames type parameters during inference only for self-recursive calls. Inside a function literal the outer signature is lost, so the check fails and the type parameters are not renamed. Unification then recurses without end.
