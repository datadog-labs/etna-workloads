# Rationale
Fix reversed: PR#6872 (`@@ -294,6 +294,7 @@ let extract_concrete_variant env ty` in typing/typecore.ml), which added
`Type_open -> (p0, p, [])` so open types (exn) give an expected type for constructor disambiguation.

Hunks:
1. typing/typecore.ml `extract_concrete_variant`: added case `Typedecl(_,_,{type_kind=Type_open}) -> Maybe_a_variant_type`
   (today's equivalent of the pre-fix fallthrough `raise Not_found`), replacing the `Variant_type (p0,p,[])` case the fix added. Expected exn type no longer drives disambiguation.
2. typing/ctype.ml: moved `exception Unify/Equality/Moregen` below `type _ trace_exn`. Not part of the fix; needed only because
   the self-compiled compiler relied on the fixed behaviour (`with Unify _` on exn) and otherwise the build fails. With the bug, the most recent definition is chosen, so this keeps the compiler source building.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> builds; pr6872.ml (and its expect variant) fail; the rest passed.
