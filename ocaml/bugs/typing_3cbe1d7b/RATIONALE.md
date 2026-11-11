# Rationale
Single hunk, `ocaml/typing/typecore.ml`, in `disambiguate_lid_a_list`, reversing fix.diff hunk
`@@ -1192,7 +1192,52 @@ let disambiguate_lid_a_list loc closed env usage expected_type lid_a_list =`
(#11630). The fix first processed user-qualified labels, then ghost-qualified ones. I reverted that to
the old behaviour: find the qualifying module, ghost-qualify every unqualified label, then process all labels in order.
In today's code `Longident.Ldot` carries located module paths, so the ghost qualification is given the
unqualified label's location (`{lid with txt = modname}`). A missing module is then reported at the
ghost `f1` location instead of the user-written `M.f2`.
(The other fix.diff hunk, which removed `find_record_qual`/`type_label_a_list` pre-qualification, is already
subsumed in the pre-existing structure; the test and Changes hunks are not edited.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tests/typing-misc/records.ml => failed (error location differs).
