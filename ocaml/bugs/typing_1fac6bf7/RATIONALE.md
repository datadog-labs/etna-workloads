# Rationale
File: ocaml/typing/ctype.ml, function `local_non_recursive_abbrev`, Tconstr case.
Reverses hunk `@@ -1641,13 +1641,11 @@ let rec local_non_recursive_abbrev strict visited env p ty =`:
the fix tries expanding the abbreviation first (since `p` may be hidden) and only checks args on Cannot_expand.
I restored the old order: check args first, on Occur try expanding, and raise Occur if it can't expand.
Test: typing-gadts/pr7374.ml fails (the hidden-path addendum is now accepted).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: pr7374.ml failed.
