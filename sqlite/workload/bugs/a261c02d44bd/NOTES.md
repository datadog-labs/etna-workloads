repro.sql runs a window function with `ORDER BY likely(2)` inside a window frame, nested in substr(), on an empty table.
Clean shell: no output, exit 0.
Buggy shell: "Parse error near line 2: Expression tree is too large (maximum depth 1000)", exit 1.
The buggy window.c doesn't skip likely() when converting integer ORDER BY terms to NULL, so the expression is handled wrongly.
