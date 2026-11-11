# Rationale

Hunks (the fix's typing/includemod.mli hunk only exports a function, so it was not reversed):

1. ocaml/typing/typecore.ml, `expand_path`: the fallback case again returns `p` without
   normalizing it. This reverses the hunk `@@ -562,7 +562,9 @@ let rec expand_path env p =`
   (today it was `Env.normalize_type_path None env p` plus a recursive call).
2. ocaml/typing/typemod.ml, `type_module_aux`, `Pmod_ident` case: the branch
   `Mty_alias p1 when not alias` is disabled (`&& false`), so a non-alias module path
   is no longer expanded and wrapped in `Tmod_constraint`/`Tcoerce_alias`. This reverses the hunk
   `@@ -954,14 +954,26 @@ let rec type_module ?(alias=false) ...`.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then
`make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: typing-modules/aliases.ml fails (the expect output shows `module F : (X : sig end) -> (module Char)`
and `module C4 = Char` instead of the expanded signatures). With hunk 1 alone the test still passed.
