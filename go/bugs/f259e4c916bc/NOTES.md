Reproducer: `repro.go` (the issue68809 program, plus a println of the count).

It counts iterations of `for i := 1; i <= 11; i++` where `i-6 > 4` (only i=11, so cnt==1).
With the injected prove-pass off-by-one (`min++` applied before the `l.max <= min` check in
the overflow `min>max` case), prove wrongly concludes the condition is never true and
folds cnt to 0. The buggy toolchain prints `0` and panics "bad" (exit 2); clean prints `1` and exits 0.

Note: use a separate GOCACHE per toolchain. Both report the same version and can share cached builds,
which hid the difference in my first attempt.
