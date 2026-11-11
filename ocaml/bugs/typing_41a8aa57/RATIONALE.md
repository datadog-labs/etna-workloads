# Rationale
Hunk: ocaml/typing/typetexp.ml, `report_error`, case `Not_a_variant ty`: replaced the `match get_desc ty with Tvar (Some s) -> Misc.did_you_mean ["`"^s]` hint with `None`.
Reverses fix.diff hunk `@@ -946,7 +946,13 @@ let report_error env ppf = function` (the PR#7012 "Did you mean `A_name?" hint).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-misc/printing.ml fails (missing Hint line).
