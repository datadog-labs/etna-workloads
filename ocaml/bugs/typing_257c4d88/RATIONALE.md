# Rationale
One hunk, ocaml/typing/mtype.ml (strengthen_lazy_sig'): reverts the ghost-row-type case from
`when Btype.is_row_name (Ident.name id)` back to only dropping a `t#row` abstract type when immediately
followed by a private type `t` (`Ident.name id = Ident.name id' ^ "#row"`).
Reverses fix.diff hunk `@@ -54,9 +54,8 @@ and strengthen_sig ~aliasable env sg p =` (code now named strengthen_lazy_sig').
Commands: `make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`: pr6985_extended.ml fails (t#row required but not provided).
