# Rationale
File: ocaml/parsing/pprintast.ml, function `binding`.
Fix hunk reversed: `@@ -1081,27 +1082,51 @@ and binding ctxt f {pvb_pat=p; pvb_expr=x; _} =` which added GADT-desugared
printing (`let f : type a. t = ...`). In today's code this is the `Pvc_constraint { locally_abstract_univars = vars; ... }` case;
I merged it into the plain-constraint case so `type a b.` is no longer printed (the pretty-printer loses the locally abstract types, so the output no longer reparses to the same AST).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: parsetree/test.ml fails (locations_test.ml passes).
