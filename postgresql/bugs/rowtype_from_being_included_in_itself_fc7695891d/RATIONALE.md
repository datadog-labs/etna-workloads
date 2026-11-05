# Rationale
- src/backend/catalog/heap.c, CheckAttributeType(): removed the `else if (att_typtype == TYPTYPE_RANGE)` branch that recursed into the range's subtype (the hunk in fix_impl.patch that adds that branch). Without it, a composite type can be used as a range subtype that contains the rowtype itself, so a rowtype can be included in itself via a range.

Failing oracle case: src/test/regress||rangetypes
