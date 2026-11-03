# Rationale

Fix hunk reversed: the `aliased` PPARAMOUT/HasDefer case (`return true` when a result
parameter is assigned in a function with defers). In go1.27.3 this logic lives in
`ascompatee` (src/cmd/compile/internal/walk/assign.go) as the `deferResultWrite` flag,
set when `name.Class == ir.PPARAMOUT && ir.CurFunc.HasDefer()`, and consulted in `affected`.
I removed the flag, its setting block, and its check in `affected`. Later expressions are
therefore no longer saved early, so the result param is written before a later
expression (e.g. `*p`) can panic.

The other fix hunk (walkstmt's `|| HasDefer()` condition) has no counterpart now:
walkReturn always routes through ascompatee.

Oracle: test/fixedbugs/issue43835.go fails with `panic: FAIL` (f() returns true after
recovering from the nil deref, since `bad` was assigned early).
