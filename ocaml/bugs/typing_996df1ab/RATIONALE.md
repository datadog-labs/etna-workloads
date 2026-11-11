# Rationale
Hunk: ocaml/typing/typetexp.ml, `Ptyp_class` case in transl_type_aux: `Env.lookup_cltype` now called with `~use:false`.
Reverses fix.diff hunk `@@ -276,6 +276,7 @@ and transl_type_aux env policy styp =` (which added `ignore(Env.lookup_cltype ~loc:lid.loc lid.txt env)` so the class type is marked used). In today's code the lookup is merged into the Ptyp_class branch, so suppressing the "use" recreates the spurious "unused open"/"unused type" warnings.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> open_warnings.ml fails (spurious Warning 33/34 in T7/T8).
