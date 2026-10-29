repro.sql runs `SELECT (1 IN (2 IS TRUE));`.
Clean shell prints 1; buggy shell prints 0, because `TRUE` on the rhs of IS inside an IN() list is not resolved as TK_TRUEFALSE (the resolve.c fix is missing).
