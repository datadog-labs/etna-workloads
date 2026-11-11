# Rationale
All changes in ocaml/typing/ctype.ml:
1. `mcomp_variant_description`: `Ident.name c1.cd_id = Ident.name c2.cd_id` -> `c1.cd_id = c2.cd_id`.
   Reverses fix hunk `@@ -2040,25 +2040,26 @@ and mcomp_type_option` (constructor names compared via Ident.name rather than raw identifiers; stamps differ so types are wrongly deemed incompatible).
2. `mcomp_record_description`: same for `ld_id` (same fix hunk, record part).
3. `unify3`: `Tconstr (_,_,_)` pattern-mode case -> `Tconstr (_,[],_)`; reverses `@@ -2271,7 +2272,7 @@ and unify3`.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh: pr5997.ml fails (both runs).
