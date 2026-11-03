repro.go is the issue52953 test program (plus a final "ok" print). `ret = T{Field1: *v}` where `v` points into `ret` (so `ret` is address-taken).
Clean: prints "ok". Buggy: oaslit lowers the assignment to `ret = T{}; ret.Field1 = *v`, so `*v` reads the zeroed field and the program panics with "FAIL".
