Input: an expando function `foo` assigned `foo.abc` and `foo[prop]` (prop = "abc" const), plus an interface with `[prop]: number` and `abc: number`.
Clean: no diagnostics. Injected: spurious "Duplicate identifier 'abc'" errors, because a late-bound member is now flagged against an early-bound one.
