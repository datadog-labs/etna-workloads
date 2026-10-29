repro.sql: REAL column with a NOCASE index holds '+/'; `c0 LIKE '+/'` should return `+/`.
The buggy shell skips the "LHS must be TEXT affinity" check when the pattern starts with '+',
so the range-scan LIKE optimization is used and the row is missed (empty result vs `+/`).
