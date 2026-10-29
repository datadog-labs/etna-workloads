repro.sql runs a one-pass DELETE whose WHERE clause has a correlated subquery reading the same table (delete4-6.0).
Clean shell prints `1`. The buggy shell, which no longer disables multi-row one-pass for subqueries, deletes rows while it scans and prints a different result.
