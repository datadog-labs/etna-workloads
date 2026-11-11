# Rationale
File: ocaml/typing/typecore.ml, function `is_nonexpansive`.
Fix hunk reversed: `@@ -1288,6 +1288,9 @@ let rec is_nonexpansive exp =` (added the `Texp_match` case).
- Removed the `Texp_match` case (match is nonexpansive if scrutinee and all case rhs/guards are), so `match` is again treated as expansive and blocks generalization (PR#6056).
- Added `Texp_match _` to the final `false` list so the match stays exhaustive (needed in today's code; the old code had no such list entry because it fell to `_ -> false`).
Commands: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh -> typing-poly/poly.ml fails (weak type variable diffs).
