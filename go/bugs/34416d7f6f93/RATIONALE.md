# Rationale

Changed `src/cmd/compile/internal/escape/call.go` in `(*escape).call`, reversing the single implementation hunk of the fix:

- `ir.OMIN, ir.OMAX` are put back into the `ODELETE/OPRINT/OPRINTLN/ORECOVER` case, whose arguments are only discarded.
- The dedicated `case ir.OMIN, ir.OMAX` (which flows each argument to `ks[0]`) is removed.

The code is otherwise equivalent to the pre-fix code. Only `ORECOVERFP` became `ORECOVER` and a `delete` comment was added, both unrelated to the fix. The result: string arguments to min/max don't flow to the result, so escape analysis misses that the result aliases the arguments.

## Oracle failures
- `test/escape_calls.go`: `strmin`/`strmax` params report "does not escape" instead of "leaking param ... to result ~r0 level=0".
- `test/fixedbugs/issue64565.go`: prints `3 2 1` instead of `3 3 3`. The string from the loop is stack-allocated and gets overwritten, so `m` is corrupted.
