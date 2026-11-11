# Rationale
Fix GPR#1970 wrapped the floating text of class fields / class sig fields in List.rev because the accumulated list is reversed. Today the grammar uses `%inline text_cstr(symb)` / `text_csig(symb)` returning `text @ [$1]` in order; I reversed the text part there.

Hunks:
- ocaml/parsing/parser.mly, `%inline text_cstr`: `text_cstr $startpos @ [$1]` -> `List.rev (text_cstr $startpos) @ [$1]`. Reverses fix hunk `@@ -1083,7 +1083,7 @@ class_fields:`.
- ocaml/parsing/parser.mly, `%inline text_csig`: same for csig. Reverses `@@ -1192,8 +1192,8 @@ class_sig_fields:`.
- ocaml/boot/menhir/parser.ml: same two semantic actions (lines ~31005, ~31065), mirroring the .mly.

Commands: `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: tests/parsing/docstrings.ml fails (floating 1/2 comments swapped).

RESULT: injected
