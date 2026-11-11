# Rationale
Hunk: ocaml/typing/typemod.ml, functor application in type_application (nondep check):
`Includemod.modtypes ~loc:app_loc ~mark:false env mty_res nondep_mty` changed to `~mark:true`.
Reverses fix.diff hunk `@@ -1995,7 +1995,8 @@ and type_module_aux ...` (which added `~mark:Mark_neither`; today's equivalent is `~mark:false`). With marking on, the check marks values as used, so the Warning 32 for unused `x` disappears.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: tests/typing-warnings/pr9244.ml fails (expected warning missing).
