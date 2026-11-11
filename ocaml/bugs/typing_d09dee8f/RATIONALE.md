# Rationale
Hunk: ocaml/typing/ctype.ml, in `copy`: removed the block `let row = match get_desc more' with Tconstr (x,_,_) when not (is_fixed row) -> ... ~fixed:(Some (Reified x)) | _ -> row in` (the PR#6163 block).
Reverses fix.diff hunk `@@ -982,6 +982,12 @@ let rec copy ?env ?partial ?keep_names ty =` (ctype.ml). Without it, a row whose `more` is a Tconstr isn't marked fixed, giving Assertion failure at ctype.ml:2736 on the pr6163 test.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: typing-gadts/pr6163.ml => failed.
