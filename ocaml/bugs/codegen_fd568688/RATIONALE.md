# Rationale
One hunk, asmcomp/cmm_helpers.ml, `untag_int`: re-added the case
`Cop(Caddi,[Cop(Clsl,[c;1]);1]) -> c` (untag_int (tag_int c) = c).
Reverses fix.diff hunk `@@ -222,30 +228,16 @@ let tag_int i dbg =` (the removed shortcut in untag_int).
Only that part was reintroduced (not force_tag_int / ignore_high_bit_int).

Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
-> tests/regression/pr9028/pr9028.ml failed (native output differs).
Final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: pr9028 still fails.
