# Rationale
One hunk, `ocaml/typing/typeclass.ml` (class_expr, Pcl_fun case): the exhaustiveness check
of a class constructor argument pattern no longer goes through `Typecore.check_partial val_env pat.pat_type ...`
(GADT/type-aware counter-example checking). It calls `Parmatch.check_partial (fun _ -> None) pat.pat_loc [Parmatch.typed_case ...]`
with a type-unaware predicate, so no counterexample is reported.
Reverses fix.diff hunk `@@ -944,7 +944,7 @@ and class_expr cl_num val_env met_env scl =` in typing/typeclass.ml
(`Parmatch.check_partial pat.pat_loc` <-> `Typecore.check_partial val_env pat.pat_type pat.pat_loc`).
The other fix hunks (exposing Typecore.check_partial) already exist in today's code.

Note: the original untyped check is not directly available today (a predicate is required), so I used a
predicate that returns None, which makes the class-argument check report nothing. This is an approximation.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest`
and `sh run-oracle.sh`: tests/typing-gadts/test.ml => failed (the PR6862 Warning 8 outputs for `class c`/`class d` are missing).
