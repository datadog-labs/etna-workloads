# Rationale
Hunk: ocaml/typing/env.ml, `check_shadowing`. The fix (`@@ -211,6 +210,33 @@ ... let same_constr = ref ...`, adding check_shadowing) skips warning 45 for constructors/labels whose types are the same re-exported type (via `!same_constr`). I removed the `when not (!same_constr ...)` guards so any shadowed constructor/label is reported (env param renamed `_env` to avoid unused-var error).
Result: tests/warnings/w45.ml fails (spurious warning 45 for A).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: w45.ml failed.
