# Rationale
Single file changed: ocaml/lambda/translcore.ml (two hunks in transl_exp0, Texp_lazy case).

1. Forward-block construction: replaced `Lprim (Pmakelazyblock Forward_tag, [transl_exp e])` with the
   old `Popaque(Pmakeblock(Obj.forward_tag, Immutable, None))` (and the separate
   `Float_that_cannot_be_shortcut` case with a plain Pmakeblock). Reverses fix hunk
   `@@ -525,23 +525,10 @@ and transl_exp0 ~in_new_scope ~scopes e =` in lambda/translcore.ml.
2. Lazy block construction: `Pmakelazyblock Lazy_tag` -> `Pmakeblock(Config.lazy_tag, Mutable, None)`.
   Reverses `@@ -557,7 +544,7 @@ and transl_exp0 ...`.

The new primitive Pmakelazyblock stays defined but unused (the other fix hunks only add support for it).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: lazy10 passed; lazy9 fails (ocamlc and ocamlopt: "Fatal error: letrec: No size found for Static binding").
