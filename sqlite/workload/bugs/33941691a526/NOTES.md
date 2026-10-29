`repro.sql` runs `SELECT 'x' LIKE '%' ESCAPE '_';`. With ESCAPE '_' the matchOne character is 0 (invalid), so the `%` loop in patternCompare must not treat the pattern's NUL terminator as matchOne.
Clean shell prints 1; buggy shell prints a different result (see check.sh output).
