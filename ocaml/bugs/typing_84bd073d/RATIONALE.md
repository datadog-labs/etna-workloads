# Rationale
One hunk, `ocaml/typing/ctype.ml`, function `unify_package`: the `Error fm_err` branch no longer
raises `Errortrace.First_class_module fm_err`. It raises `raise_unexplained_for Unify` instead.
This reverses the hunk `@@ -2908,10 +2908,16 @@ and unify3 uenv t1 t1' t2 t2' =` of fix.diff. In today's
code that logic lives in `unify_package`. First-class-module unification errors lose the
module-level explanation.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then `make clean` and a full rebuild
followed by `sh run-oracle.sh`. Result: user.ml (typing-missing-cmi-3) and firstclass.ml fail.
