repro.sql runs `select unnest(struct(...)) as alias` and `select unnest(struct_col) c1` (plus a DESCRIBE).
Clean build: the alias is ignored and the struct fields are expanded into columns.
Buggy build: each statement fails with "Internal error: Assertion failed: struct_allowed: unnest on struct can only be applied at the root level of select expression".
