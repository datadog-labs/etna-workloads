# Rationale
One hunk, in ocaml/typing/env.ml, `add_persistent_structure`: restored the pre-fix code, which always does `IdTbl.add id Mod_persistent env.modules`. It drops the `material` flag and the `-no-alias-deps` (`Clflags.no_alias_deps`) check that skips non-material additions.
Reverses fix.diff hunk `@@ -707,20 +707,34 @@ let find_name_module ~mark name tbl =` in typing/env.ml. The test hunks in the fix were not touched.
Commands: `make clean && make -j8 && make -j8 ocamltest` (OK), then `sh run-oracle.sh`. Result: cmis_on_file_system.ml => failed (compare-binary-files: .cmt files differ).
