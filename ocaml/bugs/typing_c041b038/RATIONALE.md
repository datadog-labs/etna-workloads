# Rationale
Hunk: ocaml/typing/env.ml, `add_persistent_structure`: the summary is now always `Env_persistent (env.summary, id)` (condition `true || material`), instead of only when the persistent module shadows a non-persistent one.
Reverses fix.diff hunk `@@ -696,9 +696,16 @@ let find_name_module ~mark name tbl =` (today's code has the `material` computation).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`; the test reproducibility/cmis_on_file_system.ml fails (cmt files differ).
