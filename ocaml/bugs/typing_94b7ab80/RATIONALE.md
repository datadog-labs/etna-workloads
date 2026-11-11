# Rationale
File: ocaml/typing/typecore.ml, in `type_let`: `warn_about_unused_bindings` is now computed only from the global warning state (`Warnings.is_active (check "") || ... check_strict ... || (is_recursive && Unused_rec_flag)`). The per-binding `Builtin_attributes.warning_scope ~ppwarning:false attrs` / `List.exists ... attrs_list` is removed.
This reverses the fix hunk `@@ -4056,9 +4057,13 @@ and type_let ...` (warn_unused -> warn_about_unused_bindings using attrs_list). Bindings with `[@warning "+32"]` while globally disabled no longer get unused checks.
(The slot-map `warning_scope` hunk was left as is; the one change suffices.)
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean` + rebuild + oracle. Result: warnings/w32.ml fails (output differs from reference).
