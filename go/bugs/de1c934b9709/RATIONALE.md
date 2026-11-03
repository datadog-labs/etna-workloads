# Rationale

Fix de1c934b (#46938): checkptr instrumentation for `(*[Big]T)(ptr)[:n:n]` must run after the slice bounds check. Otherwise checkptr throws a false positive instead of the expected bounds panic.

In go1.27.3 the walk-phase `CheckPtrCall` mechanism is gone. The instrumentation is emitted in SSA gen, in `src/cmd/compile/internal/ssagen/ssa.go`, in the `OSLICE3ARR` case of `expr`.

## Change
I moved the `s.checkPtrAlignment(...)` call for the `check` case from after `s.slice(...)` to before it. This reverses the fix hunk in `ssa.go`, which inserted the check after the bounds check via `s.stmt(n.CheckPtrCall)` following `s.slice`. The ordering is the same as before the fix. checkptrAlignment runs with count=Max before the slice bounds are validated. The `ir`/`walk` hunks only carried the call to that point, so they need no separate reversal.

## Oracle
`test/fixedbugs/issue46938.go` fails. With `-d=checkptr`, `(*[10]int64)(p)[:1000:1000]` now calls checkptrAlignment first. That throws a fatal "checkptr: converted pointer straddles multiple allocations" instead of the recoverable "slice bounds out of range" panic. The test crashes with a fatal error.
