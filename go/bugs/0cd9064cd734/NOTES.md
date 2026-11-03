`repro.go` passes a `chan interface{ m(int) }` to a generic `f0[T any](chan S[T])`.
Interface inference must not apply under exact unification (inside a channel element type).

- clean: `in call to f0, type chan interface{m(int)} of x does not match chan S[T] (cannot infer T)`
- buggy: infers T=int, then fails with `cannot use x ... as chan S[int] value in argument to f0`

Both exit 1; the diagnostics differ.
