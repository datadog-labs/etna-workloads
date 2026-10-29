# Rationale

Fix: ticket d9f584e936c7a8d0 — OP_SeekGE/GT/LE/LT must preserve the datatype of the key register.

Single hunk, `src/vdbe.c` (OP_SeekGT/SeekGE/SeekLE/SeekLT, `pC->isTable` branch). I reversed the fix's hunk:
- removed `flags3`/`newType` locals;
- removed the save of `flags3` and the restore `pIn3->flags = flags3` after `sqlite3VdbeIntValue`;
- the "could not convert" checks read `pIn3->flags` again instead of `newType`.

As before the fix, `applyNumericAffinity(pIn3,0)` permanently converts the key register (e.g. text '-1' becomes integer), so later uses of that register (e.g. the comparison `'-1'<=t0.c0`, with text-vs-integer-column semantics) see the wrong type.

Oracle failure: `where-26.1` (`SELECT * FROM t0 WHERE '-1' BETWEEN 0 AND t0.c0` returns wrong result). Other where-26.x cases pass for this build; one failure out of 323.
