repro.go ranges over an untyped constant into an existing float64 variable (`for i = range 10`).
Clean toolchain: type error "cannot use iteration variable of type float64".
Buggy toolchain: the missing check in types2/range.go lets it through and the compiler dies with an internal compiler error (assertion failed in compilersupport.go).
