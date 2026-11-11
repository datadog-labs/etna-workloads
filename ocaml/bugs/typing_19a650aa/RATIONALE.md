# Re-introduced bug: PR#5689 (row fixedness must account for the row's `more` type)

The fix added `Btype.row_fixed`, which treats a row as fixed when its `row_more`
is a `Tunivar`/`Tconstr` (GADT-reified or rigid), not only when the `row_fixed`
flag is set. Today this is `Btype.fixed_explanation`, plus code that stores
`Reified` in the row. I removed both, so such rows are no longer fixed.

## Hunks
1. `typing/btype.ml`, `fixed_explanation`: it now returns just the stored `row_fixed`
   field. It no longer inspects `row_more` for `Tunivar`/`Tconstr`.
   Reverses the `typing/btype.ml` hunk `@@ -126,6 +126,14 @@ let rec row_more row =`,
   which added `row_fixed` with the `Tvar|Tnil -> false | Tunivar|Tconstr -> true` logic.
   That also undoes the uses in `unify_row` and `rigidify_rec`
   (`@@ -2340,11 +2340,12 @@ and unify_row env row1 row2 =`,
   `@@ -2835,7 +2836,7 @@ let rec rigidify_rec vars ty =`), because they call this function.
2. `typing/ctype.ml`, `copy` (type instantiation): removed the block that sets
   `~fixed:(Some (Reified x))` when the copied row's `more` is a `Tconstr`.
   Without it, a row whose `more` became a `Tconstr` is no longer marked fixed.
   This is the explicit marking that replaced the fix's `row_fixed` check in today's code.
3. `typing/ctype.ml`, `create_fresh_constr` use in the GADT instance-tracking code
   (`let fixed = Some (Reified path)` is now `let fixed = None`). The fresh
   `Tconstr`-based row is no longer fixed.
   Reverses the same fix hunks as 1: the row must be treated as fixed because its more is a `Tconstr`.

## Result
`tests/typing-gadts/pr5689.ml` fails. The `linkp2` example, which should be
rejected, is now accepted (`val inlineseq_from_astseq : ast_t list -> inkind inline_t list`).

## Commands
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`, run repeatedly while
  narrowing down the change. Final run: `make clean && make -j8 && make -j8 ocamltest`, then
  `sh run-oracle.sh`. Result: pr5689.ml => failed.
