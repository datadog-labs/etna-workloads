# Rationale

fix.patch added a "NOT VALID child cannot merge with valid parent" check in two places; both are removed here.

1. src/backend/catalog/heap.c, `MergeWithExistingConstraint`: removed the `is_initially_valid && con->conenforced && !con->convalidated` error ("conflicts with NOT VALID constraint on relation"). It traces to the heap.c hunk that added `is_initially_valid` and that check. The parameter stays, so it is now unused. Without the check, a valid constraint can merge into an existing NOT VALID inherited one.
2. src/backend/commands/tablecmds.c, `MergeConstraintsIntoExisting`: removed the `parent_con->convalidated && child_con->conenforced && !child_con->convalidated` error ("conflicts with NOT VALID constraint on child table"). It traces to the tablecmds.c hunk that added that check. Without it, ALTER TABLE INHERIT accepts a NOT VALID child constraint under a valid parent constraint.

Failing oracle cases: see the oracle run output; the expected failure is src/regress inherit (sanity_check may also be affected).
