repro.sql: main and aux each have p1/c1 with an ON UPDATE CASCADE FK (c1.pid -> p1.pid).
Updating aux.p1 should cascade to aux.c1.

- clean: the UPDATE succeeds. aux.p1 holds 100, 200 and aux.c1 holds 11|100, 21|200.
- buggy: the UPDATE fails with "FOREIGN KEY constraint failed" and nothing changes. The FK cascade
  trigger is not bound to the right schema, so it resolves the child table name against another database.
