# Rationale
File: ocaml/typing/ctype.ml (only file changed).

1. `instance_constructor`: `ty_res`/`ty_args` are copied before the existentials are processed again
   (reverses fix hunk `@@ -1056,8 +1056,6 @@ let new_declaration` / `-1072,10 +1070,14`, which moved the copies after the existential linking).
2. `existential_name`: no longer uses the variable name from the constructor definition; it always yields
   the generic name "$ex" (reverses the fix's title: "use variable name from definition for existentials",
   the `link_type (copy existential)` / naming hunk at `@@ -1072,10 +1070,14 @@`). Expected test output
   changes from `$a` to `$ex`.

Commands: `make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> dynamic_frisch.ml and test.ml both failed.

RESULT: injected
