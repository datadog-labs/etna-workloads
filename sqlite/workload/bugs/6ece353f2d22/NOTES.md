Reproducer (`repro.sql`): runs `0.5 IS TRUE COLLATE NOCASE`, `0.5 IS TRUE COLLATE RTRIM` and `0.0 IS FALSE COLLATE NOCASE`, taken from istrue-710.

With the bug present, the COLLATE wrapper on the right-hand side stops `IS TRUE` from being recognised as the special TRUE/FALSE form. It is then treated as a comparison against the integer 1.

- Clean shell: prints 1, 1, 1.
- Buggy shell: prints 0, 0, 1.
