# Rationale

The fix (GPR#1133 / PR#7511) lives in `typing/typedecl.ml`. In 5.5 that check moved to
`typing/typedecl_separability.ml`, so the bug is re-expressed there. Only that file changed.

## Hunk 1: `check_type`, Deepsep case for `Tarrow` / `Ttuple`
They are now handled like the `Sep` case and return `empty`, so type variables below
an arrow or tuple are no longer checked. Reverses the fix hunk
`@@ -285,13 +285,63 @@ let make_constructor ...`, which added `check_unboxed_abstract_arg`.
That function checks every type variable inside the argument of an abstract type.
Before the fix, `Tarrow`/`Ttuple` returned `()`.

## Hunk 2: `check_type`, `Tconstr` case, and moving `best_msig`/`worst_msig`
`best_msig` and `worst_msig` moved above `immediate_subtypes` so `check_type` can call them.
A private type now gets `worst_msig` in the `Tconstr` case. This follows the fix's
reasoning that an abstract type's representation may be any sub-expression of its argument.
This hunk is not a literal reversal. It was added because the oracle's `test.ml`
has no test that Hunk 1 alone would break.
Reversing the fix's `check_unboxed_gadt_arg`/`transl_declaration` hunks (`ex` vs `univ`)
has no direct counterpart here.

Result: `type 'a packed = T : ('a, _) t -> 'a packed [@@unboxed]` is wrongly rejected in `test.ml`.

## Commands
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`: test.ml failed.
- Final `make clean && make -j8 && make -j8 ocamltest` succeeded, and `run-oracle.sh` reported `test.ml => failed`.
