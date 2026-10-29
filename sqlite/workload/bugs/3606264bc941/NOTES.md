Reproducer (repro.sql): child table t2 has an INTEGER PRIMARY KEY column `c` that references t1(a).
Inserting t2(1,'A') while t1 is empty must fail the FK check (fkey2-7.2).

- clean: "Error near line 4: FOREIGN KEY constraint failed" (the later insert succeeds).
- buggy: the first insert wrongly succeeds, because the IPK register isn't mapped to the rowid (-1).
  The later insert then fails with "UNIQUE constraint failed: t2.c".
