repro.sh builds the issue58325 test program (package p, `var _ = S1{}.Make()` where Make's body calls another inlinable method).
Clean toolchain: compiles, exit 0. Buggy toolchain: internal compiler error
"interface conversion: ir.Node is *ir.CompLitExpr, not *ir.Name" in staticAssignInlinedCall, because blank params
were not skipped when building the substitution map.
