# Rationale
File: ocaml/typing/ctype.ml, in `expand_abbrev_gen`: the `subst` call now always gets `scope = None` (was `if !Clflags.principal then Some scope else None`).
So expanding an abbreviation no longer propagates the scope recursively into the substituted type. Ambiguity inside types is no longer detected.
Reverses the fix.diff hunk `@@ -1630,12 +1632,10 @@ let expand_abbrev_gen` and the `update_scope` hunk `@@ -843,11 +843,13 @@ ... let rec update_scope`. Both made the scope update recursive. In today's code that recursion happens through `subst ?scope`.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Results: ambivalent_apply.ml and typing-gadts/test.ml fail. let_syntax.ml passes.
