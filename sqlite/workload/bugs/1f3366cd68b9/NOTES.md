Reproducer (repro.sql): a STRICT table with a REAL column `x` and a generated REAL column `y AS (x)`, then inserting the integer 5.

The OP_TypeCheck for the generated column receives an "IntReal" value. With the bug, that value is not accepted as REAL.

- Clean shell: prints `5.0|5.0||` and `4.6116860184273879e+18|4.6116860184273879e+18||`, exit status 0.
- Buggy shell: aborts on the assertion `(pIn1->flags & MEM_IntReal)==0` in sqlite3VdbeExec (exit status -6).
