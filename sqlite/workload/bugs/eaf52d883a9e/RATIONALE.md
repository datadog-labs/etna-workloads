# Rationale

Fix: removes the OP_Variable "repeat count" optimization (ticket 26ff0c82d1e90).

- `src/expr.c`, `TK_VARIABLE` in sqlite3ExprCodeTarget: reverses the expr.c hunk. Restores the merge
  of consecutive unnamed `?` parameters into the previous OP_Variable by incrementing P3 (using
  sqlite3VdbeGetLastOp, the modern form of sqlite3VdbeGetOp(v,-1)), else emits OP_Variable with P3=1.
  The named-parameter P4 code is gone in 3.54.1 (names come from a VList), so only the unnamed condition remains.
- `src/vdbe.c`, OP_Variable: reverses the vdbe.c hunk. The opcode again copies P3 parameters
  P1.. into registers P2.. in a loop, using the current copy/flag logic per register.

Failing oracle case: `bug-20100512-3` (`SELECT case when 1 then 99 else ? end + ?`). The second `?` is merged into
the OP_Variable inside the skipped ELSE branch, so it is never executed. The register is left uninitialised,
which trips `memIsValid` assertion in sqlite3VdbeExec (a wrong result in a non-debug build).
Cases 1 and 2 pass.
