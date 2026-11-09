# Rationale
fix.diff changed one hunk in `getTypeOfPropertyOfContextualType`: `!t.declaration.nameType` -> `getMappedTypeNameTypeKind(t) !== Remapping`.
In today's code that check appears twice in `getTypeOfPropertyOfContextualType` (intersection-constituent branch and the plain object branch). Both were reverted to `!<type>.declaration.nameType`, so filtering mapped types (`as` clauses that only filter) are no longer given substituted property types contextually.

SUMMARY: 2/6 oracle cases failing (2 fix-added) (errors and type/symbol baselines of contextualPropertyOfGenericFilteringMappedType.ts)
