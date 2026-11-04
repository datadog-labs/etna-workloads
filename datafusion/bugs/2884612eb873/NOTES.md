Creates a table with a column named `user` and selects/filters on the bare `user` (no parentheses).
Clean build resolves it to the column (rows returned); buggy build fails with
"Invalid function 'user'" because the fallback from function-without-parentheses to column was removed.
