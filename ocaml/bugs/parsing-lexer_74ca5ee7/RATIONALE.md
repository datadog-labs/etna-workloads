# Rationale
One hunk, ocaml/parsing/lexer.mll, rule `token`, case `"#"`: removed the `at_beginning_of_line` check so a directive (`# 1 "file"`) is accepted anywhere on a line, not only at the start.
Reverses fix.diff hunk `@@ -439,25 +439,12 @@ rule token = parse` (the part that added the beginning-of-line check; the directive rule had been already split out in today's code).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result: tests/parsing/pr6604_2.ml fails (` #1 "pr6604.ml"` is accepted instead of giving a syntax error).
