repro.go declares `var a, b nat = y()` where y returns (nat, []int), so the compiler rewrites it to an OAS2 with temporaries in the init function.
Clean toolchain compiles and prints "0 1". The buggy toolchain (OAS2 case missing in staticinit) hits an internal compiler error.
