repro.sh runs the issue36516 program with -race and prints AllocsPerRun for unsafe.Pointer arithmetic.
Clean: 0 allocs. Buggy: the checkptrArithmetic ... slice is no longer marked non-escaping, so it heap-allocates (nonzero allocs).
