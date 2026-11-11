# Rationale
Hunk: ocaml/typing/ctype.ml, `update_level`: removed the case
`Tfield(lab,_,ty1,_) when lab = dummy_method && level < get_scope ty1 -> raise_escape_exn Self`.
Reverses fix.diff hunk `@@ -731,8 +731,8 @@ let rec update_level env level ty` (typing/ctype.ml), which
made the dummy-method (self escape) check raise a proper Unify/escape error. Without it, self escaping
its class is no longer reported properly (PR#6123). The typeclass.ml hunk has no direct equivalent in today's code.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr6123_bad.ml failed (expect output differs).
