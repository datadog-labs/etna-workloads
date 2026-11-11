# Rationale

Fix: PR#5985 (injectivity of types computed; abstract types are not injective).

## Hunks
1. `ocaml/typing/typedecl_variance.ml`, `compute_variance_type`, final `List.map2`:
   `and i = concr in` -> `and i = true in`. Abstract types are again recorded as injective
   in `type_variance`. Reverses the fix's typedecl.ml hunks that make injectivity
   only hold for concrete types (`@@ compute_variance ... ` "concrete types are injective" /
   `(!co, !cn, !ct, !ij)` computation), re-expressed in today's code.
2. `ocaml/typing/includecore.ml`, `compute_variance`-inclusion check (`type_declarations`):
   dropped the `imp j2 j1` injectivity-inclusion condition. Reverses
   `@@ -247,7 +247,8 @@ let type_declarations ?(equality = false) env name decl1 id decl2 =`
   (`(not i2 || i1)`).

## Commands
`make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`:
omega07.ml passed, pr5985.ml failed (GADT `type _ g = G : 'a -> 'a t g` wrongly accepted).
