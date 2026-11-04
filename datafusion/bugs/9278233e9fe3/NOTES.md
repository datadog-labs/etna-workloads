Reproducer: runs `count(*)`, `count()` and `count(1)` over a small table.

Clean build keeps each expression's original name as the column header: `count(*)`, `count()`, `count(Int64(1))`.
The buggy build renames `count()` and `count(1)` to `count(*)`. This comes from the injected `schema_name` override in count.rs, which treats a constant Int64 argument or no argument as a wildcard. The planner no longer preserves the original name.
