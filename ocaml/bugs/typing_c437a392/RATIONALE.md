# Rationale
One hunk in ocaml/typing/typecore.ml, `collect_apply_args` (today's equivalent of `type_application`'s `type_args`).
Reverses fix hunk `@@ -4601,10 +4601,30 @@ and type_application env funct sargs =` (and `@@ -4682,23 +4702,7 @@`): the fix added an early `if sargs = [] then type_unknown_args ()` before `expand_head`, and removed `sargs <> []` from the arrow guard. I removed the early exit (the None case handles it again), restored `sargs <> []` in the Tarrow guard (and the Tfunctor case, so it can't reach `assert false`), so the function type is expanded even with no args left.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> ambivalent_apply.ml failed; final `make clean && make -j8 && make -j8 ocamltest` then oracle: failed.
