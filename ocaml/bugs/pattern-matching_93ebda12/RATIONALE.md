Hunk: ocaml/typing/parmatch.ml (non-exhaustive match message, ~line 1927): changed "extensible variant types" back to "open types".
Reverses fix.diff hunk `@@ -1812,8 +1812,8 @@ let do_check_partial` (and the message in open_types.ml.reference).
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> typing-extensions/open_types.ml fails (output mismatch).
