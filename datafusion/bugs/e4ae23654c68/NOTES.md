repro.sql runs aggregate and window-aggregate queries with `FILTER (WHERE NULL)` (untyped NULL predicate).
Clean build: returns 0 / NULL as expected. Buggy build (no FILTER coercion to BOOLEAN in type coercion): every query fails with an "Internal error" (non-boolean filter / cannot cast Null array to BooleanArray).
