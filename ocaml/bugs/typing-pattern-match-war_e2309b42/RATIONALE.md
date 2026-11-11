# Rationale
One hunk, ocaml/typing/parmatch.ml, `all_rhs_idents`: the `Texp_ident (path, ...)` case again records only plain `Path.Pident id`, instead of every head of the path (`Path.heads path`). So `M.b` in a guard no longer counts as a use of module variable `M`.
This reverses the fix.diff hunk `@@ -2165,20 +2165,56 @@ let rec do_stable rs` (the `Path.heads` part). The unpack-attribute handling in that hunk no longer exists in today's code, so I did not touch it.
Result: the PR#7031 warning 57 for `ambiguous__module_variable` is lost, and `ambiguous_guarded_disjunction.ml` fails in run-oracle.sh.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`. The test fails both times.
