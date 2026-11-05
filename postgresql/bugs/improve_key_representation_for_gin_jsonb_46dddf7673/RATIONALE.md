# Rationale

File: src/backend/utils/adt/jsonb_gin.c

1. `gin_consistent_jsonb`: for the Exists, ExistsAny and ExistsAll strategies, `*recheck` is set back to `false`. This traces to the fix.patch hunks that changed `*recheck = false` to `true` for those strategies. Without a recheck, an index match on a key that is nested rather than top-level, or on a hashed key, is returned as a true match.
2. `gin_triconsistent_jsonb`: for Exists and ExistsAny, a `GIN_TRUE` input once again gives `GIN_TRUE`, so the result is exact with no recheck. This traces to the hunk that collapsed that logic to "return GIN_MAYBE only". It brings back the same missing recheck on the bitmap and tri-state path.

Oracle case that fails: src/test/regress||jsonb
