repro.go is the upstream test issue49665.go. It declares `var x any` and `var y interface{}` and prints `%T` of `&x` and `&y`.
Clean toolchain prints `*interface {}` for both. The buggy toolchain prints `*any` for `&x` and `*interface {}` for `&y`, because the two identical types are no longer unified in the compiler.
