repro.go: calls generic `g[T any](F[T])` with `f func(F[int])`, where `type F[T any] func(func(F[T]))` (issue 59740).
Clean: reports "type func(F[int]) of f does not match F[T] (cannot infer T)".
Buggy: the unifier no longer uses exact mode for element types in assign mode, so it recurses without bound and the compiler dies with "internal compiler error: panic: unification reached recursion depth limit".
