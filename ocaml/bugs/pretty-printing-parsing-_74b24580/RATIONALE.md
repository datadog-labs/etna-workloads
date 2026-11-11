# Rationale
Hunk: ocaml/parsing/pprintast.ml, `tyvar_of_name`: removed the branch that prefixed "' " when the
second character of a type variable name is a quote. Reverses the fix.diff hunks centred on the
single print_tyvar (`@@ -28,6 +28,14 @@` in parsing/syntaxerr.ml, which added `print_tyvar`);
in today's code that logic lives in `tyvar_of_name`, used by Pprintast and Oprint (`pr_var`).
Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh.
Result: parsetree/test.ml, typing-gadts/term-conv.ml, typing-misc/printing.ml fail.
