# Rationale
- src/backend/catalog/heap.c, MergeWithExistingConstraint(): removed the check that errors with "constraint ... conflicts with inherited constraint" when `con->coninhcount > 0 && is_no_inherit`. This reverses the single fix.patch hunk (heap.c). Without it, an existing inherited CHECK constraint can be merged with a NO INHERIT one, so it stops propagating to lower-level children.

Failing oracle case: src/test/regress||inherit
