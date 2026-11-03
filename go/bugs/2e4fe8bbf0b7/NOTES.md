repro.sh compiles a generic `min[T int|float64](a, b T)` called as `min(1, 2.5)` with `-gcflags=-lang=go1.20`.
Clean toolchain: compiles fine (mixed untyped constants use the max untyped kind, no version gate).
Buggy toolchain: re-added go1.21 version gate in types2 infer, so it reports
"type float64 of 2.5 does not match inferred type int for T" and exits 1.
