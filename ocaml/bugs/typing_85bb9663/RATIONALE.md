# Rationale
Reverts the "allow disambiguation, only restrict scope of GADTs" change: out-of-scope (type-directed) resolution of a GADT constructor in a pattern is rejected again.

Hunks (ocaml/typing/):
- typecore.ml/.mli error type: added `Unqualified_gadt_pattern of Path.t * string` (fix hunk `@@ -62,7 +62,7 @@ type error =`, reversed in the direction of introducing the restriction).
- typecore.ml `Constructor/Label.disambiguate`: optional `?check_lk` argument, called in the `lookup_from_type` (out-of-scope) branch (fix hunk `@@ -594,7 +594,8 @@` and `@@ -631,6 +632,7 @@`).
- typecore.ml Ppat_construct: passes `~check_lk` raising the error for `cstr_generalized` constructors (fix hunk `@@ -915,10 +917,13 @@ let rec type_pat`).
- typecore.ml report_error: message "The GADT constructor %s of type %a must be qualified in this pattern." (fix hunk `@@ -3534,10 +3540,10 @@`).
- errortrace_report.ml, typemod.ml: qualified GADT constructors (Errortrace.Obj/Variant/Escape, Typetexp.NoMType/ComputeMType) so the compiler's own sources still build under the restored restriction (consequence, not in fix).

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-gadts/pr5848.ml failed (expect shows the new error).
