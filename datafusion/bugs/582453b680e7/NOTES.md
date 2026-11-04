Reproducer copies the case.slt test added by the fix: CASE WHEN a IS NOT NULL THEN CAST(a AS BIGINT) ELSE CAST(0 AS BIGINT) END, wrapped in count().
Clean: returns 6. Buggy: Internal error, physical vs logical schema nullability mismatch for field endpoint (physical CASE nullability does not unwrap casts).
