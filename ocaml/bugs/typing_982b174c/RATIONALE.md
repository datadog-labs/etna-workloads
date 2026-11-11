# Rationale
Fix PR#6787 (`@@ -1055,20 +1055,25 @@ let rec copy ?env ?partial ?keep_names ty =` in typing/ctype.ml) ensured that
when copying a variant type with `partial` (pattern mode), the row variable is never
shared with the original (fresh variable if `more.id == more'.id`).
In today's code the equivalent guarantee is that `keep` is false when `partial <> None`.

Hunk: typing/ctype.ml, `copy`, Tvariant case: `let keep = get_level more <> generic_level && partial = None`
became `let keep = get_level more <> generic_level`. With a partial copy the non-generic row
variable is therefore shared (more' == more) and the fresh-variable logic is not applied,
re-introducing the unsound sharing (f : 'a -> [< `Foo ] -> 'b instead of 'a).
Test changes/Changes entry in the fix are not touched.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
typing-misc/polyvars.ml => failed (expect output differs: `'b` instead of `'a`).
