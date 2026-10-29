repro.sql runs the distinct2-5080 query (GROUP BY b, b over a LEFT JOIN subquery inside a scalar subquery).
Clean shell prints 0. Buggy shell aborts with assertion `p->iTable==iReg' in sqlite3ExprToRegister
(exit -6), because the TK_REGISTER check was removed from sqlite3Select's GROUP BY handling.
