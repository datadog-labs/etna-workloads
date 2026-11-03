Reproducer (repro.sh): builds a program with `var p *[1<<50]byte`, a pointer to a type larger than the address space.
Clean toolchain: "larger than address space" error is reported at x.go:3:5 (the declaration).
Buggy toolchain: injection drops CheckSize on the pointer element type (types/size.go) and in the unified reader,
so the size is only computed later, and the same error is reported at the wrong position, x.go:5:6 (inside main).
This is a diagnostic-position difference only; I could not find a crash or wrong program output.
