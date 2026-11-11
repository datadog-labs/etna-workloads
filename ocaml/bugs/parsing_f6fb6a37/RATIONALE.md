# Rationale
One hunk, in ocaml/parsing/lexer.mll (rule `directive`): replaced the `match int_of_string num with | exception _ -> error (Invalid_directive ...) | line_num -> ...` guard with a bare `update_loc ... (int_of_string num - 1) ...`, and dropped the now-unused `as directive` binding. An out-of-range line number now escapes as an uncaught `Failure "int_of_string"`. The existing Invalid_directive type and report_error cases are left in place (unused).
Reverses the fix.diff hunk `@@ -426,11 +433,23 @@ rule token = parse` in parsing/lexer.mll. The other hunks (the error type, the message, Changes) only add support code and are left alone.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. Result: pr7165.ml fails. The output differs from the reference. The test also expects a `Syntax error` message in the output.
