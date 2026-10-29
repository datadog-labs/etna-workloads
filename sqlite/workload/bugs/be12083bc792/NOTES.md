Reproducer for window8-8.4: a CTE (`map2`) referenced from a sub-select inside the
PARTITION BY of a named WINDOW definition.

- clean: prints 2 6 12 1 4 9, exit 0.
- buggy: `Parse error near line 5: no such table: map2`, exit 1.

The injection removes the `sqlite3SelectPopWith` check in `sqlite3WalkSelectExpr`. Because of that, the window definition's sub-select is no longer walked while the CTE is in scope.
