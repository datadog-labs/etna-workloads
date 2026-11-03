repro.go is test/fixedbugs/issue44344.go (a closure called once and inlined away).
Clean: builds and prints 3. Buggy: the compiler hits a nil pointer panic (internal compiler error) in DWARF scopePCs, because scopePCs is called for a function with no Text symbol.
