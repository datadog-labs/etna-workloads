# Rationale
One hunk, in `ocaml/typing/value_rec_check.ml`, function `is_valid_class_expr`, case `Tcl_let`.

Before: `value_bindings rec_flag bindings mode (class_expr mode ce)`.
After: `Env.join (value_bindings rec_flag bindings mode Env.empty) (class_expr mode ce)`.

This reverses the fix hunk `@@ -716,8 +716,14 @@ let is_valid_class_expr idlist ce =` in `typing/rec_check.ml`. That hunk changed `class_expr env ce` to `class_expr env' ce`, so the body was checked in the environment extended by the let-bindings. In today's code the equivalent is that the body's environment is passed through `value_bindings`. I disconnected them again. Uses of `new a` through a let-bound variable (`let x() = new a in let y = x() in ...`) are then no longer detected, and the class is wrongly accepted.

Commands run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: `tests/typing-objects/Tests.ml` fails. The expect run segfaults (exit -11), which is the crash the fix describes.
