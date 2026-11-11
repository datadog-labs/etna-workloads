# Rationale
One hunk, ocaml/parsing/pprintast.ml, `Doc.ident_of_name`: removed the `| Constr, ("true"|"false") -> "%s"` case, so
constructors `true`/`false` are printed as `\#true`/`\#false`.
Reverses fix.diff hunk `@@ -108,31 +108,40 @@ let tyvar_of_name s =` (the `is_constr` exemption in `ident_of_name`, now expressed via `~kind`).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` — several tests fail (see output of run-oracle.sh).
