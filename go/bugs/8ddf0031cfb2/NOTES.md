repro.sh builds a program where a `//go:nointerface` method is used to satisfy a type constraint (`toInterface[T Fooer](FooImpl{})`), with GOEXPERIMENT=fieldtrack.
Clean toolchain: compile error "T (type FooImpl) does not satisfy Fooer (Foo method is marked 'nointerface')", exit=1.
Buggy toolchain: compiles successfully, exit=0.
