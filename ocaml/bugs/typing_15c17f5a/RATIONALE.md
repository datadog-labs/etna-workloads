# Rationale
Hunk: ocaml/typing/ctype.ml, `lower_contravariant`, Tconstr case. Reverses fix.diff hunk
`@@ -903,24 +903,30 @@ let rec lower_contravariant ...`: `maybe_expand` is now always `true`
(was `type_kind_is_abstract typ`, and `false` on Not_found), so types are always expanded, even
when not abstract / cmi is missing, giving missing-cmi errors again (typing-missing-cmi-3).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> user.ml (missing-cmi test) fails.
Final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: failure confirmed.
