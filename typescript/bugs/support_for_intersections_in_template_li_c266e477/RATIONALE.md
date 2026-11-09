Both edits are in tree/src/compiler/checker.ts.

1. `removeStringLiteralsMatchedByTemplateLiterals` corresponds to fix hunk 1. The fix removed the filter that skipped templates with an `X & {}` placeholder. I restored an equivalent filter, written inline because the fix's helper `areIntersectedTypesAvoidingPrimitiveReduction` no longer exists. Literals such as "dataDowncast" are therefore no longer removed from unions with `${string & {}}Downcast`. The `.types` baseline now shows them still present.
2. `isPatternLiteralPlaceholderType` corresponds to fix hunk 5. I restored the pre-fix rule: not generic, and at least one member is a literal or a placeholder. The fix had replaced this with a loop that allows object tags only. No test exercises this on its own.

I did not touch the fix's `objectFlags` / `getGenericObjectFlags` / `couldContainTypeVariables` / `types.ts` hunks. Today's code is already structured differently there.

Final ./check.sh summary: SUMMARY: 1/7 oracle cases failing (0 fix-added).
