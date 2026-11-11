# Rationale
One hunk, in ocaml/typing/typeclass.ml (`report_error`, case `Non_collapsable_conjunction`).
Reverses fix.diff hunk `@@ -1978,11 +1978,12 @@ let report_error env ppf function`.
The format string loses the trailing `.@ %t` and now ends with `constraints@]`. The unification
error is printed after the box is closed, instead of inside it through `%t`. The message loses
its period and the separating break.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: typing-objects/errors.ml fails (expect output differs).
