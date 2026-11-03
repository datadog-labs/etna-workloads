Reproducer (repro.go): range-over-func whose yield func has a variadic last
parameter (`func(func(int, ...string) bool)`).

Clean toolchain: types2 rejects it with "yield func of type ... cannot be variadic" (exit 1).
Buggy toolchain: the check is removed, and the rangefunc rewrite builds the body
closure as non-variadic, causing an internal compiler error
("func(#p1 int, #p2 []string) (#r bool) is not assignable to func(int, ...string) bool").
