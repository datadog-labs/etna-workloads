repro.sql runs `SELECT * FROM (SELECT 1) WHERE (STARTS_WITH() IS NULL);`.
Clean build: planning error "'starts_with' does not support zero arguments".
Buggy build: panics in starts_with.rs (index out of bounds), exit status 101, because type coercion skips signature validation for zero-argument calls.
