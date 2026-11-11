# Rationale
Hunk: ocaml/typing/parmatch.ml, `contains_extension`: now only inspects the top-level counter-example pattern instead of searching recursively (exists_pattern). This reverses the fix hunk `@@ -1810,11 +1818,7 @@ do_check_partial` / `@@ -1775,6 +1775,14 @@` (the recursive `contains_extension` that detects *extension* nested in the counter-example). Nested extension counter-examples (e.g. `[_]`-shaped) lose the explanatory message.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> open_types.ml fails.
