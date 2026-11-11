# Rationale
Hunk: ocaml/typing/typetexp.ml, `Ptyp_class` case of transl_type_aux. The lookup `Env.lookup_cltype` is wrapped so that an `Unbound_cltype` lookup error is re-raised as `Unbound_class`.
This reverses the fix hunk `@@ -275,9 +276,10 @@ ... transl_type_aux`, where `Env.lookup_class` became `Env.lookup_cltype` in the final failure branch. That change is what turned "Unbound class bar" into "Unbound class type bar". The code has since been restructured, so the revert is expressed as an error re-mapping.
Only this error-message half of the fix is reverted. The unused-open hunks (`ignore(Env.lookup_type ...)`) have no equivalent in today's code, so they were not touched.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: precise_locations.ml failed (expected "Unbound class type", got "Unbound class"). open_warnings.ml passed.
I did not run the final `make clean` rebuild; I only ran the incremental build.
