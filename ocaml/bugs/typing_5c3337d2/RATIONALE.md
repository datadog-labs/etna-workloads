# Rationale
One hunk: ocaml/typing/typemod.ml, `simplify_app_summary`: `| true , _ -> Includemod.Error.Empty_struct, mty` changed back to `Includemod.Error.Unit, mty`.
Reverses fix.diff hunk `@@ -2118,7 +2118,7 @@ let simplify_app_summary app_view = match app_view.arg with`.
The Empty_struct constructor and its handling remain (now unused for this path), so `F(struct end)` is again cast as a unit module in error messages.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: typing-modules/functors.ml fails.
