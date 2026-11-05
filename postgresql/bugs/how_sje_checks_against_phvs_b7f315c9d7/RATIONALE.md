# Rationale

Hunk: src/backend/optimizer/plan/analyzejoins.c, `remove_rel_from_query()`.
Removed the `phinfo->ph_lateral = adjust_relid_set(phinfo->ph_lateral, relid, subst);` line.

Traces to fix.patch hunk 1, which touches that same `ph_lateral` update in the same place.
The fix itself was a two-part change: drop the ph_lateral update and add a check in
`remove_self_joins_one_group()` that blocks SJE when the removed rel is in `ph_lateral`.
Later upstream code replaced that check with proper handling: it keeps ph_lateral updated and
deliberately has no PHV check ("PHVs should not impose any constraints"). So a literal reverse
does not apply. Instead I removed the ph_lateral update from the PHV handling. Self-join
elimination then leaves a PlaceHolderInfo whose `ph_lateral` still names the removed relation,
and nothing guards against it. That is the bug the fix addressed: PHVs that laterally reference
the removed rel are mishandled by SJE.

I did not touch the second hunk (the `bms_is_member(r, phinfo->ph_lateral)` check). It no longer
exists in this form.

Failing oracle case: src/test/regress||join
