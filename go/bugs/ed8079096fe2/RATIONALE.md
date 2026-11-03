# Rationale

Changed `tree/src/cmd/compile/internal/walk/expr.go` (`walkCall`): `usemethod(n)` is again called only for `OCALLINTER`.
The current condition `n.Op() == ir.OCALLINTER || n.Fun.Op() == ir.OMETHEXPR` is the descendant of the fix's walk.go hunk
(`OCALLINTER || OCALLMETH`). Reverting it means a devirtualized concrete call to `reflect.(*rtype).MethodByName` is no
longer marked (REFLECTMETHOD / R_USENAMEDMETHOD), so the linker drops exported methods. The `usemethod` reflect-package
self-skip hunk is left in place, since it is harmless without the concrete-call path.

Oracle: test/reflectmethod7.go fails — the method `M` is deadcoded by the linker, and the program crashes at runtime
(MethodByName("M") not found / panic).
