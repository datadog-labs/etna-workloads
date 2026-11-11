# Rationale

One hunk, in `ocaml/typing/ctype.ml`, function `copy_sep` (inside it, `copy_rec`).

Before: `if is_Tvar ty || may_share && TypeSet.is_empty univars && unscoped.closed ty then`
After:  `if may_share && TypeSet.is_empty univars && unscoped.closed ty then`

The explicit `is_Tvar ty` case is removed. With it gone, type variables reached
with `~may_share:false` (for example the row variable `more` of a variant, or the
tail of an object field) are no longer returned as-is when they are non-generic.
They are copied into a fresh variable instead. A non-generic row variable then
loses its identity, and the poly tests report different errors.

This reverses the part of the fix covered by the hunk
`@@ -1348,11 +1350,21 @@ let rec copy_sep ...` ("also fix Tvar case"). That hunk is
the Tvariant case, where a non-generic `Tvar` row variable is kept (`keep`) and its
levels are corrected with a delayed `copy`. The code has changed since 2022, so the
direct reversal doesn't apply. The `keep` handling in today's `copy_rec` is
unchanged. The Tvar handling is undone in the guard at the top of `copy_rec`.
This is an approximation of the fix, not a literal reversal of its hunks.

The btype.ml / btype.mli helper additions (`TypeSet.of_list`, `find_all`) are not
reverted. They only support the `shared`-with-sets code, which was inert
(`TypeSet.empty`) and no longer exists in today's code.

## Commands and results
- Edited the code, then ran `make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
  Earlier attempts that removed the `keep` branch or the static-row sharing did
  not change any test result. Removing the `is_Tvar ty` guard made typing-gadts/test.ml
  and typing-poly/poly.ml fail. typing-polyvariants-bugs/pr10664a.ml still passes.
- Final run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
  test.ml => failed, poly.ml => failed, pr10664a.ml => passed.

RESULT: injected
