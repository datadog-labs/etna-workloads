# Rationale
Hunk: ocaml/typing/typetexp.ml, `globalize_used_variables`: removed `unused := false` in the branch where the global type variable is found (`lookup_global_type_variable` succeeds).
Reverses fix.diff hunk `@@ -335,16 +335,18 @@ end = struct` (the fix added `unused := false` there). Without it, `type 'a t = [> `A] as 'a` gets a spurious unused-type-declaration warning.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; after `make clean` and full rebuild, unused_types.ml fails (the only test).
