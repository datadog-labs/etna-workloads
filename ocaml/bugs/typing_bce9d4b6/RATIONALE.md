# Rationale
Hunk: ocaml/typing/includemod.ml, `Directionality.mark_as_used`: the `Mark_positive` case now always returns true (previously only for Positive/Strictly_positive direction). So negative-side (functor argument) inclusion marks definitions as used again.
Reverses the fix.diff hunks introducing `Mark_positive`/`Mark_negative` and `negate_mark`/`mark_positive`
(e.g. `@@ -47,15 +47,32 @@ type error` in typing/includemod.ml, `if mark_positive mark then Env.mark_value_used ...`), re-expressed in today's Directionality code.
Result: w32b.ml fails (expected Warning 34 unused type t missing).
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> w32b.ml failed.
