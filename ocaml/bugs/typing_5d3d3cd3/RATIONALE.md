# Rationale
Hunk: ocaml/typing/typedecl.ml, `check_unboxable`. Reverses fix.diff hunk
`@@ -1739,7 +1739,7 @@ let check_unboxable env loc ty =` (`type_unboxed.default` replacing `.unboxed`).
Today's code tests `tydecl.type_unboxed_default`; the old field `type_unboxed.unboxed` no longer
exists, so I re-expressed it as "type_kind is an unboxed variant/record". Warning 61 is now
emitted for types that are [@@unboxed] and not for unannotated unboxable types.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/typing-unboxed/test.ml => failed (output differs from reference).

RESULT: injected
