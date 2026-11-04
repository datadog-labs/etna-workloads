`repro.sql` runs `select factorial(-1);`.
Clean build: execution error "factorial of a negative number is undefined".
Buggy build: returns 1 (injection makes negative inputs yield 1 instead of an error).
