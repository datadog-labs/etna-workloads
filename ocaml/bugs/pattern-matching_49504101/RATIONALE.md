# Rationale
Single file: ocaml/typing/parmatch.ml. The fix's typecore.ml hunk (`@@ -1006,8 +1006,10 @@ Ppat_var` special case) and the Conv hunks no longer exist in today's code, so only the parmatch ones are reversed.

1. `build_other`: reverses fix hunk `@@ -781,10 +781,10 @@ let build_other ...`. The `*extension*` counter-example is again a `Tpat_construct` that keeps the original extension constructor, renamed to "*extension*" and given no arguments. It is no longer a `Tpat_var`. For a GADT constructor like `IPair : (int*int) -> t`, the counter-example no longer type-checks in `partial_pred`. The warning is therefore dropped (PR#7330).
2. `contains_extension`: reverses hunk `@@ -1743,7 +1745,7 @@ let contains_extension pat`. It matches `Tpat_construct` with `cstr_name="*extension*"` again.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`. Result: typing-extensions/open_types.ml fails, because the expected Warning 8 for `f = function IPair ...` is missing.
