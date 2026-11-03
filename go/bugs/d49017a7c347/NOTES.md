repro.go calls `g[T any](...T)` with a `*os.File` and an `any` argument.
Clean: unification fails with "type any of b does not match inferred type *os.File for T".
Buggy: the interface/non-interface check in unify.go is missing, so T is inferred as *os.File
and the error is instead "cannot use b ... as *os.File value in argument to g: need type assertion".
