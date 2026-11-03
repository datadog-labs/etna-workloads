repro.go passes a slice-to-array-pointer conversion `(*[2]int)(s)` as a call argument alongside another call.
The injection removes OSLICE2ARRPTR from the "might panic" list in walk.mayCall.
- go-clean: compiles; the program runs and panics at runtime (exit 2) with the conversion-length panic.
- go-buggy: the compiler fails with `internal compiler error: mayCall SLICE2ARRPTR`.
