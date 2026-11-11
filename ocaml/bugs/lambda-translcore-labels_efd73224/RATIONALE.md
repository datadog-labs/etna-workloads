# Rationale
One hunk, ocaml/lambda/translcore.ml (`build_apply` in `transl_apply`): removed
```
let args' = List.map (fun (arg, opt) -> protect "arg" arg, opt) args' in
```
This reverses the fix hunk `@@ -670,29 +685,36 @@ and transl_apply ~scopes` (the part that added the evaluation of delayed optional args via `protect`). Delayed optional arguments are no longer evaluated before the closure is built, so their evaluation order is wrong (#10652).

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: basic-more/labels_evaluation_order.ml fails (bytecode and native output differ from reference).
