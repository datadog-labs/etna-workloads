# Rationale
File: ocaml/typing/ctype.ml, `build_subtype`, `Tarrow` case.
Changed `| Tarrow(l, t1, t2, _) ->` to `| Tarrow(l, t1, t2, com) -> assert (is_commu_ok com);`.
Reverses fix.diff hunk `@@ -4055,8 +4055,7 @@ let rec build_subtype env visited loops posi level t =` (which removed `assert (com = Cok)`), adapted to the current `is_commu_ok` API.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: typing-misc/labels.ml fails with Assertion failed at ctype.ml line 5495.
