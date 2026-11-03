repro.go is the issue45175 test program (loop whose phi/stack-slot handling is wrong in the buggy compiler).
f(false) should return 0. The clean toolchain exits 0; the buggy one returns 2, prints "got 2" and panics (exit status 2).
