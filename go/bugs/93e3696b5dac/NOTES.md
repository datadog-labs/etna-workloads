repro.go is the upstream test test/fixedbugs/issue67255.go (issue 67255).
It runs `append(s, make([]*byte, zero)...)` with zero == 0 on slices whose backing arrays fill their size class, while the GC runs.
go-clean exits 0 with no output.
go-buggy crashes with a SIGSEGV nil pointer dereference (exit status 2).
The buggy compiler computes a past-the-end pointer &s[len(s)-l2] and passes it to memclr even when l2 is 0. That pointer can point into the next, unallocated object, and the write barrier then crashes on it.
