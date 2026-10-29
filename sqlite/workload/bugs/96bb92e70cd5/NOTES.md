repro.sql runs `SELECT decimal(0.0)==decimal(-0.0), decimal(-0.0);` (decimal is built into the shell).

Clean shell: `1|0`. Buggy shell: negative zero isn't special-cased in decimalFromDouble(), so decimal(-0.0) is converted as a nonzero denormal-like value. It prints a huge digit string, and the equality with decimal(0.0) is false.
