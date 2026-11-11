# Rationale
Hunk: ocaml/typing/out_type.ml, `non_shadowed_stdlib`: removed the check that the unqualified name
resolves (via Namespace.lookup) to the same path; Stdlib prefix is again elided unconditionally.
Reverses fix.diff hunks `@@ -48,12 +48,19 @@ let ident ppf id` / `@@ -63,7 +70,7 @@ let rec path` in typing/printtyp.ml
(the non_shadowed_pervasive check; code now lives in out_type.ml as non_shadowed_stdlib).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` (also after make clean): tests/typing-warnings/pr6587.ml fails (prints "fpclass" instead of "Stdlib.fpclass").
