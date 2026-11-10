# Rationale
Changed hunk: checker.ts (resolveUnionOrIntersection members, ~line 15084) — removed the `/*skipObjectFunctionPropertyAugment*/ !!(type.flags & TypeFlags.Intersection)` argument from `getPropertyOfUnionOrIntersectionType`, matching fix.diff hunk 1 (reversed). Intersection property enumeration again pulls in Object/Function global augmentations (e.g. from global augmentation), producing spurious errors in intersectionIncludingPropFromGlobalAugmentation.ts.
The other fix hunks (cache handling, getPropertyOfType intersection branch) were left intact; only hunk 1 was needed.

SUMMARY: 1/24 oracle cases failing (1 fix-added).
