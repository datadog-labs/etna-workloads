repro.go calls unsafe.SliceData / unsafe.Slice with type parameters constrained by ~[]E / ~*E.
Clean toolchain compiles and prints `7 [7]`; the buggy one (uses Underlying() instead of the core type)
rejects it with "is not a slice" / "is not a pointer" errors.
