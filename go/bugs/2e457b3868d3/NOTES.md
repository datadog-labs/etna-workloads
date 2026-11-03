repro.go is the upstream issue62515 test (generic func using unsafe.Sizeof/Alignof/Offsetof on a composite literal with side-effecting expressions).
go-clean compiles and runs it fine (exit 0). go-buggy fails with "internal compiler error: unused auto: .autotmp_6" (exit 1), because the unified frontend builds the argument expression and leaves unused temporaries.
