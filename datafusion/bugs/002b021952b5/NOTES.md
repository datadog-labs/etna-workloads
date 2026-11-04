`repro.sql` runs `CREATE EXTERNAL TABLE ... WITH ORDER (a || b)`, where the order expression can't be planned (no column `a`).
Clean build: reports `Schema error: No field named a.` (exit 0). Buggy build: panics on an `unwrap()` in statement.rs (exit 101).
