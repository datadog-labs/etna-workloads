repro.sh writes package `a` (A[_ B[any]] with B having a method returning A[B[any]], a cyclic generic constraint) and package `b` that uses a.A[a.B[any]], then builds ./b.
The compiler imports `a` from export data via the lazy loader. Clean toolchain: builds fine (exit 0).
Buggy toolchain: the compiler deadlocks on the Named mutex (Named.unpack) and prints "fatal error: all goroutines are asleep - deadlock!" with exit 1.
