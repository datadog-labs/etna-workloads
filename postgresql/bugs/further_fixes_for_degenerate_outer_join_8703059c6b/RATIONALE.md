Changes are all in src/src/backend/optimizer/plan/initsplan.c, make_outerjoininfo(), reversing the initsplan.c hunks of fix.patch:

1. Re-added the early "if (bms_is_empty(min_righthand)) min_righthand = bms_copy(right_rels);" right after min_righthand is first computed (reverses hunk 1 of the fix). Degenerate clauses then force the full syntactic RHS before the lower-OJ loop runs.
2. Removed the late empty-min_righthand fallback near the Assert (reverses the last hunk).
3. Removed `!bms_overlap(clause_relids, otherinfo->min_lefthand) ||` from the lower-OJ check (reverses the middle hunk), so SpecialJoinInfos can again end up with identical min_righthands.

The joinrels.c hunks were not reverted; the initsplan.c changes alone reproduce the failure.

Failing oracle case: src/test/regress||join
