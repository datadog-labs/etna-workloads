# Rationale

Changes in src/backend/catalog/heap.c:

1. `cookDefault()`: removed the `check_virtual_generated_security()` call for virtual generated columns
   (fix hunk "Check security of expressions for virtual generated column"). Generation expressions may again
   use user-defined functions/types. The now-unused helper is marked `pg_attribute_unused()` to avoid warnings.
2. `CheckAttributeType()`: removed the check rejecting user-defined types (>= FirstUnpinnedObjectId) when
   `CHKATYPE_IS_VIRTUAL` is set (fix hunk "For consistency with check_virtual_generated_security()").

The catversion bump is not reverted (not behaviorally relevant).

Failing oracle cases:
- src/test/regress||generated_virtual
- src/test/regress||publication
