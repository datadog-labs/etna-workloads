Reproducer: `m.Header[""] = append([]string(m.Header[""]), "")` (map index wrapped in a OCONVNOP conversion inside append).
Clean toolchain compiles and prints 1; the buggy toolchain's order.go does an unchecked type assertion to *ir.IndexExpr and the compiler panics (internal compiler error).
