# Rationale
File: ocaml/otherlibs/str/str.ml, function `parse`, '(' case. Reverses the fix hunk
`@@ -518,12 +518,10 @@ let parse s =`: restores the 32-group limit (`if group_no < 32 then incr group_counter;`
and groups >= 32 are non-binding (`(r, j+2)`), so Str.matched_group fails for them.
Only this hunk was reverted.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/lib-str/t01.ml fails.
