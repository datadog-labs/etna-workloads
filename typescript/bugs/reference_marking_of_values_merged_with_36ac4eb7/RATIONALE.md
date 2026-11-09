# Rationale
Today's code already has the `getSymbolFlags(symbol, excludeTypeOnlyMeanings, excludeLocalMeanings)` form of the fix. I reverted the two reference-marking hunks to the pre-fix form:

1. `markAliasReferenced` (fix hunk "@@ -27818"): the condition is back to `... && !getTypeOnlyAliasDeclaration(symbol, SymbolFlags.Value)` and the flag check uses `getSymbolFlags(target)`. A value merged with an unresolvable type-only import is again not marked as referenced.
2. `markExportAsReferenced` (fix hunk "@@ -4577"): `getSymbolFlags(target) & Value && !isConstEnum... && !getTypeOnlyAliasDeclaration(symbol, Value)`. This is the same pre-fix behaviour.

Result: typeOnlyMerge3.js and importEquals3.js baselines differ (the exports/imports are elided wrongly).

SUMMARY: 2/721 oracle cases failing (0 fix-added).
