# Rationale
Hunk: ocaml/typing/out_type.ml, `let enabled = ref true` -> `ref false`.
The fix (PR#6416, GPR#1120) introduced the unique printed-name mechanism (Naming_context, which ocamldoc turns off via `Naming_context.enable false`; fix hunks `@@ -14,6 +14,7 @@ open Format` in ocamldoc/odoc_print.ml and odoc_str.ml). In today's code that is `Out_type.enabled`/`enable`. Defaulting it to false removes unique names (`t/2`) and related printing behaviour.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr6416, pr6634, unique_names_in_unification, pervasives_leitmotiv, pr4791, pr6323, pr7402 fail.
