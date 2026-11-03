Reproducer (repro.sh): compiles package `a` (a constructor whose returned closure captures its
parameter) and package `b` (`var _ = a.NewA(0)`) directly with `go tool compile`.
Clean toolchain: compiles fine (rc=0). Buggy toolchain: static init inlines the call and
substitutes the arg for the captured param, giving
`internal compiler error: 'init': value a.i (nil) incorrectly live at entry`.
(Plain `go build` did not trigger it in my attempts; direct compile does.)
