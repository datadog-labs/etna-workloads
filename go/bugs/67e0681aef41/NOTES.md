Reproducer: `repro.go` (from test/fixedbugs/issue73476.go). It ranges over `(*p)` with a nil `*[4]int` and only uses the index.

Clean: the range doesn't dereference `p`, so it prints 0..3 and exits 0.
Buggy: the parenthesized `(*p)` isn't recognized as a deref-only range, so the compiler dereferences nil. The program panics with a nil pointer SIGSEGV and exits 2.
