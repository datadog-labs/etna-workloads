# Rationale
Fix (MPR#7704) made the exhaustiveness counter-example pattern for open variants a special tag
(`any_extra_tag`) and made `type_pat_aux` skip unifying that tag with the expected type
(hunk `@@ -1249,7 +1249,8 @@ and type_pat_aux` in typing/typecore.ml). In today's code this is
`some_private_tag` (PR#7404 lineage).

1. typing/typecore.ml `solve_Ppat_variant`: removed the `if tag <> Parmatch.some_private_tag` guard so
   the tag is always unified with the expected type. Reverses the typecore.ml hunk `@@ -1249,7 +1249,8 @@`.
2. typing/parmatch.ml `build_other`: the counter-example for a fixed (private) row no longer uses the
   special tag, but an ordinary `AnyOtherTag`. Reverses parmatch.ml hunks `@@ -980,6 +980,8 @@ build_other`
   / `@@ -1017,7 +1019,7 @@` (introduction/use of the special tag constant).

Ran: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`; typing-misc/polyvars.ml fails
(expected "`<some private tag>", got "`AnyOtherTag").
