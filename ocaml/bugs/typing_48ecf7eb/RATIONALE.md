# Rationale
Fix (PR#6410) added `Access_functor_as_structure` so that `F.x` with F a functor reports
"The module F is a functor, not a structure" (hunk `@@ -189,7 +190,14 @@ let rec narrow_unbound_lid_error` in typing/typetexp.ml, plus the error type/report hunks).
In today's code that logic lives in typing/env.ml `lookup_structure_components`: the
`Ok (Functor_comps _)` case raised `Functor_used_as_structure lid`. I changed it to raise
`Unbound_module lid`, so the confusing, unhelpful error comes back (reverses the check hunk in
typetexp.ml; the other hunks only add the constructor/message, now represented by `Functor_used_as_structure`).
Only one line changed: typing/env.ml line ~2975.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/typing-modules/Test.ml => failed (expected message differs).
