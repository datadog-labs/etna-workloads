# Rationale
Hunk: ocaml/typing/parmatch.ml (non-exhaustive match message for extensible variants): "extensible variant types" -> "open types".
Reverses fix.diff hunk `@@ -1812,7 +1812,7 @@ let do_check_partial ...` (the message text; today's code lives in a Format_doc printer near line 1927). The test reference hunk was not touched.
Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh` -> tests/typing-extensions/open_types.ml failed (message mismatch).
