Reproducer: repro.go (test/typeparam/issue50833.go minus header). It uses elided composite literal
elements `[]P{{f: 1}}` where P is a type parameter whose core type is a pointer to struct.
Clean toolchain compiles and runs it (exit 0, no output). Buggy toolchain fails to compile with
"invalid composite literal element type P" (types2 literals.go no longer uses commonUnder for the hint).
