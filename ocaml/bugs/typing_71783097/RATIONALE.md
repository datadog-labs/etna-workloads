# Rationale
File: ocaml/typing/ctype.ml, `subtype_row` (closed-row case, Tvar/Tconstr/Tnil).
- Removed the `Rpresent None, Rpresent (Some _) | Rpresent (Some _), Rpresent None -> subtype_error ... Incompatible_types_for l` case, so these fall to `raise Exit`; and the binder `(l,f1,f2)` went back to `(_,f1,f2)`. Reverses hunks `@@ -5087,7 +5087,7 @@ and subtype_row ...` and `@@ -5104,7 +5104,12 @@`.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: typing-misc/polyvars.ml fails.
