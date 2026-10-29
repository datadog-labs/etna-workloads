repro.sql: `SELECT ('abc'='ABC' COLLATE nocase x1100);` — a chain of COLLATE operators deeper than the default expression depth limit (1000).
Clean: "Parse error ...: Expression tree is too large (maximum depth 1000)".
Buggy: COLLATE nodes don't count toward nHeight, so no error; the query returns 1.
