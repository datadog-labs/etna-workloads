`repro.go` uses a generic alias of a signature type, `type B[P any] = func()`, as an uninstantiated conversion: `var _ = B(nil)`.

- Clean toolchain: reports `cannot use generic type B without instantiation`.
- Buggy toolchain: `nonGeneric` in types2 no longer checks `*Alias`, so the error is missed and the compiler hits an internal compiler error (`B has 0+1 params, but instantiated with 0+0 args`).
