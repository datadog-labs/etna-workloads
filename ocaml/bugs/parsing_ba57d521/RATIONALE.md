# Rationale
One hunk, ocaml/typing/typecore.ml, `vb_exp_constraint`: the `Pvc_coercion` case now builds `Exp.constraint_ expr coercion` instead of `Exp.coerce ~loc expr ground coercion`. Coercions on value bindings (`let x :> t = e`, `let x : g :> t = e`) are then treated as plain type constraints.
It reverses the fix.diff hunk `@@ -2951,28 +2951,33 @@ let vb_exp_constraint ...` in typing/typecore.ml (the `Pvc_coercion` branch added by the fix). Before the fix, the parser reduced coercions to a plain type (`_, Some t -> t`).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: tests/exotic-syntax/exotic.ml fails (type error on `let x :> <m:int> = object ... end`). The two parsetree tests pass.
