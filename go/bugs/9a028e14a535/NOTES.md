Reproducer for #66585: `var b = x` is initialized after `var a = foo()`, and foo() (inlined) increments x.
The buggy compiler statically folds b to 0 (staticopy ignores the inlined call); the correct output is `1 1`, buggy prints `1 0`.
