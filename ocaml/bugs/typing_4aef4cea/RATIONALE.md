# Rationale
Hunks (reverting the location refinement of PR#7315):
- typing/typedecl.ml, Pext_rebind in transl_extension_constructor: lookup_constructor uses ~loc:sext.pext_loc instead of lid.loc. Reverses fix hunk `@@ -1329,7 +1329,7 @@ let transl_extension_constructor` (find_constructor env sext.pext_loc).
- typing/typetexp.ml, Ptyp_constr in transl_type: lookup_type uses ~loc:styp.ptyp_loc instead of lid.loc. Reverses `@@ -340,7 +340,7 @@ let rec transl_type` (find_type env styp.ptyp_loc).
Commands: make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh -> extensions.ml fails (location of "Unknown" is whole extension), precise_locations fails too.
