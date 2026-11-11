# Rationale
File: ocaml/typing/typecore.ml, `solve_Ppat_construct`.
Fix hunk reversed: `@@ -1159,10 +1159,10 @@ let rec type_pat ...` (PR#7214: do not use gadt unification for toplevel lets).
In today's code that logic is `let refine = constr.cstr_generalized && no_existentials = None`.
Changed to `let refine = constr.cstr_generalized`, so GADT refinement is again used for toplevel lets
(no_existentials set). The now-unused parameter was renamed `_no_existentials` (needed to avoid the unused-variable warning-as-error); the PR7214 comment was dropped.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh.
Result: tests/typing-gadts/pr7214.ml fails (expect output differs).
