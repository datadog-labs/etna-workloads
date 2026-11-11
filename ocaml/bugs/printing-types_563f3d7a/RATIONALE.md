# Rationale
One hunk, typing/out_type.ml, `name_of_type`: removed the lookup `try TransientTypeMap.find t !weak_var_map with Not_found ->`.
Reverses fix.diff hunk `@@ -416,15 +425,23 @@ let rec new_name () =` / `-let name_of_type t =` (typing/printtyp.ml in 2017), which added the weak_var_map lookup so weak variables remember their names ('_weakN) across toplevel phrases.
Effect: weak names are regenerated, so pr248.ml / omega07 / unify_mb etc. print wrong names.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr248.ml, omega07.ml failed. Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: failures present.
