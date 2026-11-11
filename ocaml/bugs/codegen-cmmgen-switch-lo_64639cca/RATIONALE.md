# Rationale

One hunk, `ocaml/asmcomp/cmm_helpers.ml`, in `make_switch`, function `extract_uconstant`.

The case for `Cconst_natint` used to accept only tagged constants (low bit 1) and emit `Cint n`. Now it accepts any natint. It allocates a boxed nativeint constant and puts a pointer to it in the table (`Csymbol_address`) instead of the tagged integer.

This reverses the fix.diff hunk `@@ -1348,28 +1357,27 @@ let transl_isout ...` (`make_switch`). That hunk replaced `Cconst_natint _ -> true` and `to_uconst`'s `Cconst_natint n -> const (Uconst_nativeint n)` with a tagged-only check and `Cint n`. Before the fix, big constants such as `min_int` and `max_int`, which are `Cconst_natint`, were stored as boxed values.

The other hunks of fix.diff are refactors (`cmm_constants`, `Const_table`) that today's code already has. They are not reverted.

## Commands and results
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`: `switch_opts.ml` fails in native mode with `Assert_failure("switch_opts.ml", 74, 0)`, which is `test_int_min_int`. The bytecode run passes.
- Final `make clean && make -j8 && make -j8 ocamltest`, then `run-oracle.sh`: still fails.

RESULT: injected
