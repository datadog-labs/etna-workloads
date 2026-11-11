# Rationale
One hunk: ocaml/parsing/pprintast.ml, `function_param`: `Pparam_newtype ty -> pp f "(type %a)@;" ident_of_name ty.txt` reverted to `"(type %s)@;" ty.txt`.
Reverses fix.diff hunk `@@ -627,7 +631,7 @@ and sugar_expr ctxt f e =`. Raw identifiers like `\#begin` in `(type ...)` are printed unescaped.
Commands: `make -j8 && make -j8 ocamltest` (incremental, ok), then `sh run-oracle.sh` -> a parsetree test fails (see output above). A final clean rebuild was not run.
