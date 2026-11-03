`repro.sh` writes the upstream issue81612 test program (a stack-allocated append backing store whose element-field address `&matches[0].ID` escapes) and runs it with `go run -trimpath`.

Clean toolchain: exits 0. Buggy toolchain: the slice pass does not treat `&s[i].f` as ending exclusivity, so the pointer returned points into a dead stack frame. After `clobber` overwrites that stack, the program prints `resolve: after clobber: 3735928559` and panics.

The script sets its own `GOCACHE`. The release-versioned clean and buggy compilers have the same build ID, so a shared cache returns the clean toolchain's binary to the buggy one and hides the bug.
