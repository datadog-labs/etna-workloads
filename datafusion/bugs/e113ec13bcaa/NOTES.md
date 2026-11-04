repro.sql creates a table with no NULLs and runs `nth_value(column1, 1) IGNORE NULLS OVER (ORDER BY column2)`.
Clean build returns 3,3,3,3; the buggy build returns NULL for every row (the evaluator returns early with a NULL scalar when valid_indices is empty, instead of falling back to the normal path).
