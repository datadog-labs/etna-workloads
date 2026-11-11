# Rationale
Hunk: ocaml/typing/typecore.ml, `solve_Ppat_construct`. `refine` was `constr.cstr_generalized && no_existentials = None`; now just `constr.cstr_generalized`, so GADT refinement is used in toplevel lets again (removed the PR#7214 comment; param renamed `_no_existentials` to avoid unused warning).
Reverses fix hunk `@@ -1158,10 +1158,10 @@ let rec type_pat ...` in typing/typecore.ml (the `no_existentials` condition for gadt unification).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: pr7214.ml fails.
