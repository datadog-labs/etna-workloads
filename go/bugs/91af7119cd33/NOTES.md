repro.go declares methods on an instantiated alias (`type A0 = T[int]`) and on a generic alias (`type A1[P any] = T[P]`).
Clean toolchain: reports "cannot define new methods on instantiated type T[int]" and "... on generic alias type A1[P any]".
Buggy toolchain: internal compiler error (nil pointer dereference panic) at the type declaration.
