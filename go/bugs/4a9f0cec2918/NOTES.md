repro.sh builds and runs the issue47928 program with GOEXPERIMENT=fieldtrack. The program checks that a `//go:nointerface` method promoted through an embedded struct is not visible to an interface type assertion.
Clean toolchain: prints "ok". Buggy toolchain: panics with "FAIL", because the method is wrongly treated as satisfying the interface.
