repro.go is test/typeparam/issue50002.go: a generic function does type switches/assertions to a type A that cannot implement I[T] for some instantiations (string vs I[byte]).
With the bug, ITabLsym no longer allows non-implementing itabs, so the compiler fails/crashes on this instantiation; clean builds and runs it silently.
