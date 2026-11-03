repro.go calls `CallM2(X{})` where the constraint has a core type (X) plus a method `M() R`.
Clean toolchain infers R from X's method and prints 42. The buggy compiler skips method-based
inference when the constraint has a core type, so it fails with "cannot infer R".
