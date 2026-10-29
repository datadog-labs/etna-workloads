# Ticket #1444 re-injection

The fix added `Select.disallowOrderBy`, set while a UNION ALL arm is processed
under an ORDER BY, so that `flattenSubquery()` refused to flatten an ORDER BY
view into that arm (`(p->disallowOrderBy || p->pOrderBy) && pSub->pOrderBy`).

In 3.54.1 the compound-with-ORDER-BY case goes through `multiSelectOrderBy()`,
where each arm carries the ORDER BY in `p->pOrderBy`. The restriction is
therefore covered in two places, both keyed on `p->pOrderBy`. I disabled both
for arms of a compound select (`SF_Compound`), which restores the pre-fix
state where flattening saw an arm with no ORDER BY:

1. `flattenSubquery()`, restriction (11): `p->pOrderBy && pSub->pOrderBy`
   now also requires `(p->selFlags & SF_Compound)==0`. Reverses the
   `flattenSubquery` hunk (the missing `disallowOrderBy` check).
2. `sqlite3Select()`, "omit superfluous ORDER BY" condition (5): the
   `p->pOrderBy!=0` term now also requires a non-compound `p`. This is the
   second path that covers the same case (it drops the view's ORDER BY when
   the outer has one, which would mask the missing check in 1). Same defect.

Both changes are in src/select.c. No struct or `multiSelect` hunk is needed
because the `SF_Compound` flag stands in for `disallowOrderBy`.

## Oracle result
`test/tkt1444.test`: all four cases (1.1-1.4) fail. The view's ORDER BY is
flattened into the arm that already has an ORDER BY, and
`assert(pParent->pOrderBy==0)` in `flattenSubquery` fires (crash).
