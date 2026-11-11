# Rationale
Reverses fix "fix a problem where short-paths is not working for some polymorphic variant types".
- typing/outcometree.mli: `Ovar_typ of out_type` -> `Ovar_name of out_ident * out_type list` (reverses hunk `@@ -70,7 +70,7 @@ type out_type`).
- typing/oprint.ml: print Ovar_name with print_typargs/print_ident (reverses `@@ -212,8 +212,8 @@ and print_simple_out_type`).
- typing/out_type.ml (was printtyp.ml): re-added `inh` computation with fallback using the unshortened path `p` and `tyl` (reverses `@@ -604,20 +604,15 @@ let rec tree_of_typexp`).
Result: `val a : [< int u > `A ]` printed instead of `[< t > `A ]`.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: pr6836.ml fails.
