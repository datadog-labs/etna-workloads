# Rationale
File typing/ctype.ml, function `moregen` (one logical change, two edits):
- Re-added `(Tunivar _, Tunivar _) -> unify_univar_for Moregen t1 t2 !univar_pairs` as the first case on the unexpanded types (reverses fix hunk `@@ -2060,9 +2060,7 @@ let rec moregen ...`, which removed it).
- Removed the `(Tunivar _, Tunivar _)` case on the expanded types t1', t2' (reverses hunk `@@ -2106,6 +2105,8 @@`, which added it). So abbreviations expanding to a univar (type 'a t = 'a) are not expanded before the univar comparison.
The unrelated formatting hunk (Tpackage) was not reverted.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-poly-bugs/pr5322_ok.ml fails (type error on compile).
