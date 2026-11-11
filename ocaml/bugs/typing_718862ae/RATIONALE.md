# Rationale
Hunk: ocaml/typing/typetexp.ml, `Ptyp_alias` case of transl_type_aux: removed the `check_tyvar_name env alias.loc alias.txt;` call (today's equivalent of the `valid_tyvar_name` check added by fix.diff hunk `@@ -518,6 +518,9 @@ and transl_type_aux ...`). `_ as '_a` is thus no longer rejected.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typetexp_errors.ml fails (missing error).
