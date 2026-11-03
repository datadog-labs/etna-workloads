repro.go declares `type T1 struct{ _ T0[T1] }` and `type X A[X]` (generic T0/A), both invalid recursive types through an instantiated generic type.
Clean toolchain: reports "invalid recursive type T1" / "X" and exits 1.
Buggy toolchain: validType only looks at the origin type, misses the cycle, and the compiler dies with a stack overflow (infinite recursion in noder.isNotInHeap).
