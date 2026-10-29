repro.sql inserts two rows with NULL in column a (same b) and creates a UNIQUE index on (a,b).
Rows with a NULL in the key are distinct, so the clean shell succeeds (exit 0).
The buggy shell's sorter comparison ignores the NULL rule and fails with
"UNIQUE constraint failed: t4.a, t4.b" (exit 1). This matches unique-4.8/4.9.
