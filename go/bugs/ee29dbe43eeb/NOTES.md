`repro.go` calls a generic `f[P any](x P) P` with a value of local alias type `A = int`, then does `b + "foo"` to provoke a type error.

Clean: the error says `mismatched types A and untyped string`. Buggy: it says `int and untyped string`, because unification unaliases the type argument and loses the alias name (go.dev/issue/67628).
