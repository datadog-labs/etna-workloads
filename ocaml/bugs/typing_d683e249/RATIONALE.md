# Rationale
File: ocaml/typing/typecore.ml (only file changed)

1. `disambiguate_lid_a_list` (process_label): `Env.lookup_all_labels ~loc:lid.loc` -> `~loc`
   (whole record's loc). Reverses hunk `@@ -536,9 +536,9 @@ let type_label_a_list` (find_label env lid.loc -> env loc),
   so "Unbound record field label" is reported at the whole record/pattern (PR#5073).
2. `type_label_exp`: `Private_label` error uses `loc` instead of `lid.loc`.
   Reverses hunk `@@ -2367,8 +2367,10 @@ and type_label_exp`.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-misc/records.ml failed
(location differences). Final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh: records.ml fails.
