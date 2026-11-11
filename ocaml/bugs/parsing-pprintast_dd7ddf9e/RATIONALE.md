# Rationale
One hunk, parsing/pprintast.ml, `binding`: added a case before the `Pvc_constraint { locally_abstract_univars = []; typ }` case. When the expression has attributes and the constraint is a `Ptyp_poly`, it prints `(p : typ) = e` instead of `p : typ = e`.
This reverses the fix.diff hunk `@@ -1255,7 +1255,16 @@ and binding ctxt f {pvb_pat=p; pvb_expr=x; _} =`. That hunk added a special case for `x.pexp_attributes <> []` with a poly-annotated var pattern. Today's code stores the constraint in `pvb_constraint`, so the same special case is re-expressed there.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`. tests/parsetree/test.ml failed.
Final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh: the failure is still there.
