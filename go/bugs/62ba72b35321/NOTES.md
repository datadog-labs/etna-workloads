`repro.sh` builds a package `a` whose function uses the method expression `T1.M`, where `T1` embeds `*T2` and `M` is promoted from `T2`. It builds with `-gcflags=-m`.

- go-clean builds the package and prints the inlining diagnostics. Exit status is 0.
- go-buggy fails with `internal compiler error: type T1 has no method M` and exits 1.

The injection makes `NewMethodExpr` search `mt.Methods()` instead of calling `CalcMethods` and using `mt.AllMethods()`. Promoted methods are then missing from the lookup.

The error only appears with `-gcflags=-m`. Without it both toolchains succeed, so the script passes that flag. Both toolchains report themselves as go1.27.3 and share the build cache, so the script is only reliable on a cold cache. `check.sh` runs it that way.
