# Rationale
One hunk, `ocaml/typing/typedecl.ml`, in `report_error`, case `Non_regular`: the "after the following expansion(s)" clause is never printed (condition made `false && ...`).
It reverses the fix.diff hunk `@@ -1656,15 +1669,41 @@ let report_error ppf = function`, which added the expansions list to the non-regular error. Without it the message omits the expansion chain.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. polyvars.ml, Tests.ml and poly.ml (and other tests that show expansions) fail.
