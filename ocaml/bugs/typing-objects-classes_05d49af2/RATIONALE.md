# Rationale
Hunk: ocaml/typing/ctype.ml, `add_method`: in the `Mprivate k` / `Public` case, the `Fprivate` branch no longer calls `link_kind ~inside:k field_public` (now `()`).
Reverses fix.diff hunk `@@ -3366,8 +3375,13 @@ let add_method env label priv virt ty sign =` (the fix added `link_kind ~inside:k field_public` so that overriding a private method with a public one updates the privacy in the self row). Without it, the method stays private in the object type ("It has no method test" case, #10781).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-objects/Tests.ml fails.
