Reproducer (repro.go): `f(g)` where `g[Q int](Q)` is a generic function passed as an argument to generic `f[P any](P)`.
Clean toolchain compiles and runs it (exit 0, no output). The buggy toolchain, which lacks the step that clears the type parameters of a signature that is no longer generic after inference simplification (go.dev/issue/59953), rejects it:
`cannot use g (value of type func(int)) as func[Q int](int) value in argument to f`.
