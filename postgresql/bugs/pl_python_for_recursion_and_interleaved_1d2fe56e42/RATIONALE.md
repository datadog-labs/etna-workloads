# Rationale

## src/pl/plpython/plpy_exec.c, PLy_exec_function (SETOF "second or later call" branch)
Traces to the fix.patch hunk adding the `else` branch that calls
`PLy_function_restore_args(proc, srfstate->savedargs)` on later calls of a SRF.
The bug is reintroduced by dropping the saved args (PLy_function_drop_args) instead of
restoring them into the globals dict. When several evaluations of the same
set-returning function are interleaved, the later calls see the argument values
of whichever call ran last rather than their own.

Oracle cases failing: src/pl/plpython||plpython_setof (plpython_spi still passes).
