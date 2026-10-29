`repro.sql` runs `SELECT abs(-9223372036854775807-1);` (abs of the smallest 64-bit integer).
Clean shell: "Runtime error: integer overflow". Buggy shell: the negation wraps, so it returns -9223372036854775808.
