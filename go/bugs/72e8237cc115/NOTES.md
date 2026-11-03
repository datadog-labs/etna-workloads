repro.go is the issue74908 test (struct embedding `any` is built from a typeObject{e struct{}; b *byte}, a direct-interface struct with a zero-size field) plus a main that calls it.
Clean toolchain: compiles and prints `true`. Buggy toolchain: internal compiler error "'f': not lowered: v13, Empty STRUCT", because the IMake/StructMake rewrite only matches single-arg StructMake.
