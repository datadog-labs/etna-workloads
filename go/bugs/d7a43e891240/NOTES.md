repro.go is test/typeparam/subdict.go: it declares `type C comparable` and uses it as a constraint on a generic type whose method calls another instantiation.
Clean toolchain: compiles and runs, exit 0, no output.
Buggy toolchain: internal compiler error "cannot write underlying interface of comparable", exit 1.
