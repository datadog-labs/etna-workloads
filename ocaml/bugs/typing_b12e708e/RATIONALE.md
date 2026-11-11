# Rationale
File: ocaml/typing/typecore.ml (Pexp_coerce ground-coercion branch, ~line 5355).
Changed `if not gen && !Clflags.principal then` back to `if not gen then`, so Warning 18
"this ground coercion is not principal" is emitted even without -principal.
Reverses fix.diff hunk `@@ -2450,7 +2450,7 @@ and type_expect_ ...`.
The other hunk (`separate = ...`) is already in the fixed form in today's code.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh:
tests/typing-warnings/coercions.ml fails (unexpected warning in Test1 output).
