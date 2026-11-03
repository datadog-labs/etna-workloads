`repro.go` is the issue71857 test (atomic.Uint64.Or result stored through 8 pointers under register pressure), with a Store(5) beforehand and a final Println.

Clean toolchain: prints `5 2735`, exit 0.
Buggy toolchain: the regalloc injection lets a temporary register be reused, so a pointer register is clobbered. The program dies with a nil-pointer SIGSEGV in main.f (exit 2).
