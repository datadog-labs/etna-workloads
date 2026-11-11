# Rationale
Hunk: ocaml/typing/printpat.ml, `Tpat_record` case in `pretty_val`: the empty-`filtered_lvs` branch
printed `"{ _ }"`; changed to `"{}"`. This reverses the fix hunk `@@ -198,9 +191,17 @@ let rec pretty_val ppf v` in typing/parmatch.ml
(which added the `[] -> fprintf ppf "_"` branch; before it, an unconstrained record printed with no
wildcard). Today's code's equivalent is in printpat.ml.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
exhaustiveness.ml fails (expects `({ _ }, 1)`).
