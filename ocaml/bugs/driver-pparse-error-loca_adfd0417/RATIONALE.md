# Rationale
Hunk: ocaml/driver/pparse.ml, `file_aux`, marshalled-AST branch (`is_ast_file`): removed the
`begin match In_channel.with_open_bin !Location.input_name set_input_lexbuf ... end;` block.
This reverses fix.diff hunk `@@ -175,6 +187,12 @@ let file_aux ...`. Without it, Location.input_lexbuf is not set
for marshalled ASTs, so error messages lack quoted source (regression #12697).
(The helper set_input_lexbuf is still used by the source branch, so the other hunk is left as is.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tool-ocamlc-locations/marshalled.ml fails (check-ocamlc.byte-output differs); test.ml passes.
