# Rationale
One hunk, `ocaml/parsing/pprintast.ml`, in `binding`: the case `Some (Pvc_constraint { locally_abstract_univars = []; typ })` used to print `pat : typ = expr`. It now ignores the type and prints `pat expr` through `pp_print_pexp_function`.

This reverses the fix hunk `@@ -1093,9 +1093,11 @@ and binding ctxt f {pvb_pat=p; pvb_expr=x; _}`. That hunk re-enabled the `Pexp_constraint (e,t1), Ppat_var` case, which prints `let x : t = e`. Without it, the constraint was lost when the AST was printed. Today's AST represents this case as `Pvc_constraint`, so the case was changed there.

The fix's other hunks are a whitespace change and test edits, so I did not touch them.

Commands run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: `locations_test.ml` passed. `parsetree/test.ml` failed in both native and bytecode, because the pretty-printed output differs from the reference.
