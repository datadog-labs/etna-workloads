# Rationale
Hunk: ocaml/typing/ctype.ml, `compatible_labels`: removed `|| in_pattern_mode` from the classic check (now `l1 = l2 || !Clflags.classic && not (optional...)`); parameter renamed `~in_pattern_mode:_` to avoid unused-var error.
Reverses fix hunk `@@ -2426,7 +2426,8 @@ and unify3 env t1 t1' t2 t2'` (which added `|| !umode = Pattern` to the label-compat condition; today's equivalent is compatible_labels).
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> typing-gadts/pr7432.ml fails.
