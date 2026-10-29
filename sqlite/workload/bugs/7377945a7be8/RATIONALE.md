# Rationale

Fix: OP_VCreate took its table name from a register loaded with OP_String8 (which converts to the db encoding, so malformed UTF-8 round-trips in UTF-16 databases to the same name stored in the schema). Reverted to the pre-fix form.

- `src/vtab.c` sqlite3VtabFinishParse: reverses the hunk that added `iReg` + `OP_String8` + `OP_VCreate iDb,iReg`. Back to `OP_VCreate iDb,0,0,P4=pTab->zName` (copied, strlen+1). The unused `iReg` declaration is removed.
- `src/vdbe.c` OP_VCreate: reverses the hunk that copied the register and used sqlite3_value_text. Back to `sqlite3VtabCallCreate(db, pOp->p1, pOp->p4.z, ...)`; opcode comment restored to P4 form.

The raw UTF-8 name from the parser is used for the lookup instead of the name that was round-tripped through UTF-16 into the schema, so the lookup finds the wrong/no table.

Oracle: vtab2-5.2 fails (assertion `pTab && IsVirtual(pTab) && !pTab->u.vtab.p` in sqlite3VtabCallCreate; run aborts so 5.3 also fails).
