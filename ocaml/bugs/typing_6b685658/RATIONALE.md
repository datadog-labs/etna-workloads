# Rationale
Hunk: ocaml/typing/typetexp.ml, report_error `Not_a_variant`: message changed from "does not expand to a polymorphic variant type" back to "is not a polymorphic variant type". Reverses fix.diff hunk `@@ -845,7 +845,8 @@ let report_error env ppf = function` (typetexp.ml).
Commands: `make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`: polyvars.ml and printing.ml fail.
Not run: the final `make clean` rebuild. The incremental build was used instead.
