repro.go is test/fixedbugs/issue50672.go. It checks that in `f()(g())`, where g returns multiple values, f() is called before g(), as the spec requires.
go-clean exits 0. go-buggy panics with "FAIL" in main.init (the package-level `var _ = f()(g())`) with exit status 2, because g() runs before f().
