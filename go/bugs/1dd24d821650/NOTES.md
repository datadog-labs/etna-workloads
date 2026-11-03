repro.go calls g(x) where g[P any](T1[P]) and x is T1[int], with P unused in the interface T1.
Clean: compile error "cannot infer P" (exit 1). Buggy: the compiler wrongly infers P=int, so it compiles and runs (exit 0).
