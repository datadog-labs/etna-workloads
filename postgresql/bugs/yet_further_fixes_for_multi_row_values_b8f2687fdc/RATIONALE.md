# Rationale

File: src/backend/rewrite/rewriteHandler.c (all hunks trace to fix_impl.patch's single file)

- `rewriteValuesRTE` (prototype + definition): re-added the `force_nulls` parameter and the
  `!force_nulls` conditions (searchForDefault skip, auto-updatable-view check, build_column_default),
  and removed the INSERT/RTE_VALUES asserts. Traces to the hunks that removed `force_nulls`.
- `rewriteValuesRTEToNulls`: removed (prototype and function), as the fix added it.
- `RewriteQuery`: the first call passes `false` for force_nulls; the DO ALSO product-query call
  again uses `rewriteValuesRTE(pt, ..., rt_entry_relation, true, NULL)` instead of the
  target-relation-independent NULL replacement.

Why this brings the bug back: product queries from DO ALSO rules on an auto-updatable view may not be
INSERTs and may have no meaningful target relation, so the generic rewriteValuesRTE path, which
uses that relation's tuple descriptor and the INSERT-specific logic, is wrong for them.

Failing oracle case: src/test/regress||updatable_views
