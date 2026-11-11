# Rationale
Re-adds `passive_variants` (reverting fix for #7520, #9547).
- typing/ctype.ml, after `let rigid_variants = ref false`: re-added `passive_variants` and `with_passive_variants` (reverses hunk `@@ -2506,15 +2506,6 @@ let unify_package`).
- typing/ctype.ml `unify_row_field`: re-added `not !passive_variants &&` in `redo` (reverses `@@ -2974,7 +2965,6 @@`).
- typing/ctype.ml: re-added `if not !passive_variants then` before merging univar types (reverses `@@ -3000,7 +2990,6 @@`).
- typing/ctype.mli: re-exported `with_passive_variants` (reverses `@@ -258,8 +258,6 @@`).
- typing/typecore.ml `partial_pred`: wraps `check_counter_example_pat` in `Ctype.with_passive_variants` (reverses `@@ -1846,11 +1846,7 @@`).
The Changes/test hunks are not touched.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: tests/typing-gadts/pr7520.ml fails (refutation case reported as not refuted).
