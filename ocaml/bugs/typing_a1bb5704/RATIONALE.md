# Rationale
Hunk: ocaml/typing/typecore.ml, `is_ignore` in type_application. It now only checks `is_prim ~name:"%ignore" funct`, dropping the check that the primitive's type is an arrow (try filter_arrow_mono ... with Filter_arrow_mono_failed -> false).
Reverses fix.diff hunk `@@ -3508,10 +3508,17 @@ and type_application env funct sargs =` (which added the Unify guard in is_ignore). So `external foo : int = "%ignore"; foo ()` raises uncaught Filter_arrow_mono_failed (PR#6946).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: pr6946_bad.ml fails.
