# Rationale
File: ocaml/typing/typemod.ml, `patch_deep_item` (deep `Sig_module` case).
Fix hunk reversed: `@@ -521,10 +521,20 @@ let merge_constraint ...` which added a special case so that
`with type`/`with module` going through a `Mty_alias` module leaves the alias item unchanged.
In today's code that logic is the `Mty_alias _, false` branch (leave `current_item`); I removed it,
so aliases are replaced by `Mty_signature newsg` (weakened). `current_item` renamed `_current_item` to avoid unused warning.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/typing-sigsubst/sigsubst.ml fails (module M2 = M1 expanded to a signature).
