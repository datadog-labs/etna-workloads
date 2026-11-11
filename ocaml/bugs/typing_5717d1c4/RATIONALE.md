# Rationale
Hunk: ocaml/typing/typecore.ml, `partial_pred`'s counter-example check: removed `~force:true` from the
`wrap_trace_gadt_instances ~force:true !!penv (...)` call (so GADT instance tracing is only enabled when the env
has local constraints). Reverses fix.diff hunk `@@ -2533,7 +2533,8 @@ let partial_pred ...` in typing/typecore.ml
(the protection by wrap_trace_gadt_instances ~force:true). The ctype.ml `?force` plumbing is left in place (harmless, unused).
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> typing-gadts/pr13579.ml fails.
