# Rationale
All changes in `ocaml/typing/ctype.ml`, function `occur_rec`. Reverses fix.diff hunk
`@@ -1637,22 +1637,17 @@ let rec occur_rec env visited ty0 ty =` (typing/ctype.ml), re-expressed in today's code
(which uses a `parents` set and `visited` marks):
1. In the `Tconstr` expansion handler (`with Occur -> try let ty' = try_expand_head ...`), the
   plain recursive call `occur_rec ... ty'` is replaced by the old inlined version: check
   `eq_type ty' ty0`, skip Tobject/Tvariant, bail on allow_recursive, else iterate on ty' directly.
2. In the default (`| _ ->`) case, the cycle guard (`allow_recursive || TypeSet.mem ty parents`)
   is removed, so it unconditionally iterates the children (the fix had added the
   `List.memq ty visited` guard there). Cyclic types then make the occur check loop/overflow.

Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: tests/typing-gadts/pr7016.ml => failed (the expected "Warning 8" output is missing).
