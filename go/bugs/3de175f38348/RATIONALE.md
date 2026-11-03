# Rationale

Fix hunk: in prove(), `addLocalFacts` was moved to after the `ft.unsat` check so
that local facts (e.g. an unconditional panic from `make([]T, -2|i)`) cannot
mark a block unreachable.

In go1.27.3 `addLocalFacts` is gone as a block-level call; local facts are added
per value by `ft.flowLimit(v)` / `ft.addValueFact(b, v)` in the loop after the
`ft.unsat` check. Change (src/cmd/compile/internal/ssa/prove.go): moved the
`topoSortValuesInBlock` + per-value fact loop to *before* the `if ft.unsat`
check (`simplifyBlock` stays after). A contradiction found from local facts now
makes the block be removed via `removeBranch`, as in the pre-fix code.

Oracle: test/fixedbugs/issue68816.go fails (the compiler crashes while compiling
it, instead of the program running and panicking only where it must).
