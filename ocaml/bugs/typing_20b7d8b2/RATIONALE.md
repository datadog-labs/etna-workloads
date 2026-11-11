# Rationale
One hunk, typing/ctype.ml (nondep_type_rec_aux, Tconstr case), reversing
`@@ -4643,22 +4643,24 @@ let rec nondep_type_rec ?(expand_private=false) env ids ty =`.
The fix first tries keeping constructor p and falls back to expanding abbreviations
on Nondep_cannot_erase. I restored the old behaviour: expand only when p mentions
a removed id (and raise Nondep_cannot_erase if expansion fails); otherwise keep p
and recurse on arguments (so `X.t always_int` args fail to be erased).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-modules/nondep.ml failed.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: nondep.ml failed.
