repro.go is the upstream issue78295 test program: a defined pointer type B (*struct{ A }) whose struct embeds interface A, with A having a method taking B. It calls (*b).m(b).
go-clean compiles and runs it (exit 0, no output). go-buggy fails with "internal compiler error: declared pointer receiver type: B" (exit 1).
