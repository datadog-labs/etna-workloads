# Rationale
- src/backend/optimizer/prep/prepjointree.c, remove_useless_results_recurse(): fix_impl.patch hunk 2 (JOIN_LEFT case for larg). Reverted so the LHS child of a LEFT JOIN no longer gets parent_quals (always NULL), so single-child FromExprs below commutable left joins aren't removed, bringing back "wrong varnullingrels" failures.
- The comment hunk was not reverted (comment only).

Failing oracle case: src/test/regress||join
