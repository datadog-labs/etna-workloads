Method value `a.m` on a generic interface `A[T]` (T instantiated with string) and then calling it.
Clean: runs fine. Buggy: runtime fatal error "unreachable method called. linker bug?" (exit status 2).
The program re-runs itself as a child and prints only the first line of its output, so the
output is deterministic (no addresses from the goroutine dump).
