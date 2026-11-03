repro.go declares `type X[T any] interface { X[*T] }` and uses `var _ X[int]` (issue 56665).
Clean toolchain: reports "invalid recursive type: X[*T] refers to itself" and exits 1.
Buggy toolchain: the compiler never terminates (infinite instantiation of X[*T], X[**T], ...), because the generic origin type is not marked invalid. Run with a timeout.
