Reproducer: repro.go. A range clause `for _, x := range func() []int { return x.m() }() {...}` where `x` inside the closure should refer to the function parameter `x` (type T), while the range variable `x` is an int.

Clean toolchain: compiles and runs (exit 0). Buggy toolchain: the range scope is opened before the range expression is checked, so the closure's `x` resolves to the int range variable. It fails with `x.m undefined (type int has no field or method m)`.
