# Rationale
Hunk: ocaml/typing/typedecl.ml, `is_fixed_type`.
Reverses fix.diff hunk `@@ -86,13 +86,21 @@ let is_float env ty =` (typing/typedecl.ml), which replaced the old
non-recursive criterion with a `has_row_var` helper that looks through nested aliases
and only treats open objects / open or fixed variants as fixed. I restored the old criterion:
any Ptyp_variant/object/class (or one alias level around them) counts as fixed.
So closed private objects are treated as private row types instead of private abbreviations,
and nested aliases are missed (PR#6331).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: typing-private/private.ml fails (including the toplevel variants).
