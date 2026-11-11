# Rationale
Hunk: ocaml/typing/typecore.ml, `is_nonexpansive_struct_item`: `Tstr_open` removed from the `is_nonexpansive_mod m` case and made `false`.
In today's code `let open M in e` is `Texp_struct_item (Tstr_open, e)`, so this reverses the fix hunk
`@@ -1831,7 +1831,8 @@ let rec is_nonexpansive exp =` (which made Texp_open's module expression count as nonexpansive).
Result: `let open Fn in fun ...` is treated as expansive and is weakly typed.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/generalized-open/expansiveness.ml => failed (weak variables where generalized ones are expected).
