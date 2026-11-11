# Rationale
File: ocaml/lambda/matching.ml (all hunks reverse fix.diff's changes to lambda/matching.ml)
- Context sig: removed `val erase_first_col` — reverses `@@ -489,6 +489,8 @@ module Context`.
- Row: removed `Row.erase_first_col` — reverses `@@ -522,6 +524,11 @@`.
- Context: removed `erase_first_col ctx` — reverses `@@ -567,6 +574,8 @@`.
- `bind_match_arg` (today's home of the fix's `combine_handlers` code, `@@ -3477,7 +3486,7 @@`):
  the `Mutable` case no longer applies `Jumps.map Context.erase_first_col`, so contexts from
  mutable-field reads are propagated to later re-reads (unsound); comment sentence mentioning the function trimmed.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` (incremental), then final
`make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: partiality.ml, test_contexts_code.ml,
test_contexts_results.ml all fail.
