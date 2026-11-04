`repro.sql` runs three queries with invalid function arguments (`position(1 in 1)`, `sqrt(1, 2)`, `regr_slope(1, '2')`).

- **Clean build:** the error reads `Error during planning: Failed to coerce arguments ...`.
- **Buggy build:** the planning error is wrapped twice, so it reads `Error during planning: Error during planning: ...`.
