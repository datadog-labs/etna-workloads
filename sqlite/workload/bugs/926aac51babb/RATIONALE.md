# Rationale

Reverses the `src/insert.c` hunk of the fix: in `sqlite3ComputeGeneratedColumns()`
the `else if( pOp->opcode==OP_TypeCheck ){ ... pOp->p3 = 1; }` branch is removed.
For STRICT tables with STORED generated columns, the OP_TypeCheck emitted before
the columns are computed is then no longer told (P3=1) to skip generated columns.
It therefore type-checks the not-yet-computed stored columns, as before the fix.
(The vdbe.c hunk is not reverted: today's OP_TypeCheck was rewritten with P3 also
encoding a virtual column index, and the P3 skip logic is still needed there. The
bug reappears purely by never setting P3.)

Failing oracle cases (test/strict1.test): strict1-7.1 (the fix's own test: STRICT
table with VIRTUAL + STORED generated columns, INSERT fails/gives wrong result
instead of `4 2 1`), plus strict1-9.1, 9.2.13/21/23/24/34/41/42/43, which give
wrong type-error messages.
