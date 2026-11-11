# Rationale
File: ocaml/typing/typecore.ml, in `check_rec` (Tpat_lazy case): changed `~info:(no_explosion info)` to `~info`, and removed the "do not explode under lazy: PR#7421" comment. I also removed the helper `no_explosion`, which became unused and would fail the build under warning 32.
Reverses the hunk `@@ -1320,7 +1320,8 @@ let rec type_pat ...` in typing/typecore.ml. That hunk passed `~explode:0` when typing the sub-pattern of a lazy pattern. In today's code the equivalent is `no_explosion info`.
Effect: a counter-example pattern under `lazy` is exploded again, so the unsound GADT refutation in pr7421.ml is accepted.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: tests/typing-gadts/pr7421.ml fails.
