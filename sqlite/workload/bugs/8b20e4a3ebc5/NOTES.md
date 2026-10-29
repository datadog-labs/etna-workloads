Renames a column used in a trigger whose body has a compound SELECT with a 2-term ORDER BY (`ORDER BY b,c`).
The injected `break` in resolveOrderGroupBy stops after the first term in rename mode.
Clean: the trigger SQL is rewritten (`c` -> `ccc`). Buggy: ALTER fails with "error in trigger r1: 2nd ORDER BY term does not match any column in the result set" (exit 1).
