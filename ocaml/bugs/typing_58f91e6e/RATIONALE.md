# Rationale
All hunks in ocaml/typing/printtyp.ml (today's code lives there, with helpers in out_type.ml):
- `constructor`: removed `add_constructor_to_preparation c;` — reverses fix hunk `@@ -1466,10 +1466,13 @@ and tree_of_label l` (prepare_type_constructor_arguments / prepare_type c.cd_res in `constructor`).
- `label`: removed `prepare_for_printing [l.Types.ld_type];` — reverses same hunk (`prepare_type l.ld_type` in `label`).
- `extension_only_constructor`: removed `prepare_type_constructor_arguments ext.ext_args;` and `Option.iter add_type_to_preparation ext.ext_ret_type;` — reverses hunk `@@ -1537,6 +1540,8 @@ let extension_constructor id ppf ext`.

Commands: `make -j8 && make -j8 ocamltest`, `sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle: inclusion_errors.ml fails (expect killed, stack overflow/loop on recursive types).
