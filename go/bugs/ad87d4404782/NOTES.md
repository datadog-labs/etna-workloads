repro.go receives from a channel of type parameter T (constraint ~bool) in a comma-ok assignment: `var x, ok T = <-ch`.
Clean toolchain compiles and prints "true true". The buggy one uses isBoolean instead of allBoolean in
types2 recordCommaOkTypes, so the assertion fails: internal compiler error, exit status 1.
