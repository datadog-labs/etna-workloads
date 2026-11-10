# Rationale
Today's code moved the first fix hunk (property lookup) into `getTypeOfConcretePropertyOfContextualType` in checker.ts.
1. Hunk 1 (fix.diff @29247): `removeMissingType(getTypeOfSymbol(prop), optional)` -> `getTypeOfSymbol(prop)`. Contextual type of optional properties again keeps the `missing` type under exactOptionalPropertyTypes.
2. Hunk 2 (@29324): tuple element `removeMissingType(getTypeArguments(t)[index], ...)` -> `getTypeArguments(t)[index]`. Same for optional tuple elements.

Final: SUMMARY: 2/12 oracle cases failing (2 fix-added).
