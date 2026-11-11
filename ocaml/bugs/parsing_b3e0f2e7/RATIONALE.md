# Rationale
Hunks (today's code; the fix's parser.mly is now parsing/ast_helper.ml):
1. ocaml/parsing/ast_helper.ml `varify_constructors`: removed `check_variable` and its three calls (Ptyp_var, Ptyp_alias, Ptyp_poly). Reverses fix hunks `@@ -212,70 +212,23 @@ let exp_of_label` / `@@ -283,10 +236,13 @@ let varify_constructors` in parsing/parser.mly (type variables may again share a name with a local type, no Variable_in_scope error). Variable_in_scope constructor left in place (unused error type).
2. ocaml/typing/errortrace_report.ml: the "last" elidable trace element is no longer appended (unification `error` and `Subtype.trace`), i.e. keep_last is effectively always false. Reverses fix hunks in typing/printtyp.ml `@@ -936,12 +936,12 @@ let rec trace fst txt ppf` and `@@ -1108,13 +1108,13 @@ let report_unification_error` (introduction of `keep_last`).
The ctype.ml / typeclass.ml / test hunks were not reversed (not needed).

Commands: `make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: tests/typing-gadts/test.ml => failed (the line "Type "a" is not compatible with type "b"" is missing from the Eq error output).
