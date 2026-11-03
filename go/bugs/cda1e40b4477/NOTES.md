Reproducer (repro.sh) compiles `type A = int; type T[P any] *A; var _ T[int]` (issue 65778).
Clean toolchain compiles fine (exit=0). Buggy toolchain's compiler overflows its stack
(writer.go no longer resolves the materialized alias's Rhs), so the build fails with
"fatal error: stack overflow"; only stable lines of the output are printed.
