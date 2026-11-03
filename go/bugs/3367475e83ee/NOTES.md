repro.go assigns generic `g[P any](P, string)` to `func(int, String)` (String's underlying type is string).
Clean: inference error "inferred type func(int, string) for func(P, string) does not match type func(int, String) of f".
Buggy: inference succeeds via assignment-style unification, then fails with "cannot use g (value of type func(int, string)) as func(int, String) value in variable declaration".
Both exit 1; only the diagnostic differs.
