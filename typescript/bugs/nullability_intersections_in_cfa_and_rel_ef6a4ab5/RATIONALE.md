# Rationale
Changed hunk (checker.ts, getNormalizedUnionOrIntersectionType): restored the old condition
`some(type.types, isEmptyAnonymousObjectType)` in place of `shouldNormalizeIntersection(type)`, and removed the
now-unused `shouldNormalizeIntersection` helper. This corresponds to fix.diff hunks 1 and 2. Intersections such as
`Partial<T>[K] & ({} | null)` (instantiable + nullable, no `{}` member) are no longer normalized, so the
indexedAccessAndNullableNarrowing test produces spurious errors.
The third fix hunk (removeNullableByIntersection) was left alone.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
