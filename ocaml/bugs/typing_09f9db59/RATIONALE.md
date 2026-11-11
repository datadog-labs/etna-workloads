# Rationale
Reverses fix.diff (typing/typemod.ml, `merge_constraint`), re-expressed in today's code.

- ocaml/typing/typemod.ml, With_type case for objects with `#row` (fix hunk `@@ -560,15 +556,17 @@ ... let row_id, ghosts = split_row_id s ghosts in`):
  the row item is no longer rebuilt in place within `ghosts`; ghosts are just before+after (row removed), and the row is emitted right after the type item (via new `~extra`), as before the fix.
- Same file, `return_payload`: new optional `?extra` to carry the extra items (replace_by is an option today, a list in 2021, so the list form is re-expressed this way). Reverses the `replace_by:[...; Sig_type(id_row..)]` part of the same fix hunk.
- ocaml/typing/signature_group.ml/.mli: `in_place_patch` gets `extra`, emitted after the replaced item.
- The second fix hunk (`@@ -577,7 +575,8 @@`, plain type case) is unchanged here, it is the same in the pre-fix code modulo the ghost recombination.

Test: with_ghosts.ml fails (output has spurious `and t#row`/`and u#row` inside the group).
Commands: `make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> with_ghosts.ml => failed.

RESULT: injected
