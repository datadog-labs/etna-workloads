repro.sh builds the issue68415 test program (regexp + unique.Make) with `-a -gcflags=all=-d=checkptr` and runs it.
Clean: prints "ok", exit 0. Buggy: the compiler inlines runtime functions (internal/abi.NoEscape) into checkptr-instrumented code, so the program dies with "fatal error: checkptr: pointer arithmetic result points to invalid allocation" (exit 2).
`-a` and a private GOCACHE force the standard library to be rebuilt with the toolchain under test.
