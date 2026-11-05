# Rationale

## Changed hunk
File: src/backend/optimizer/plan/analyzejoins.c, function `remove_rel_from_eclass`.

Traces to the fix.patch hunk that added, at the top of `remove_rel_from_eclass`, a loop calling
`remove_rel_from_phvs()` on every EquivalenceMember expression (when `sjinfo != NULL` and the
query has PlaceHolderVars), before the early-return check on `ec_relids`.

I removed that loop. Member expressions then keep the removed rel and join in the phrels and
phnullingrels of any PlaceHolderVar. A member's em_relids reflects ph_eval_at rather than phrels,
so these stale references survive even when the EC's relids don't mention the removed rel. This
is the bug the fix removed: a later pull_varnos() can reference the nonexistent rel.

The other fix hunks (restrictinfo PHV stripping, the helper functions) are left as is.

## Failing oracle cases
- src/test/regress||join
