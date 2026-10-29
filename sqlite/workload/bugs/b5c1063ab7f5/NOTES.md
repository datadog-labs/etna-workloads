`repro.sql` creates two tables and runs `EXPLAIN PRAGMA integrity_check`.

The P4_INTARRAY argument of OP_IntegrityCk is rendered wrongly in the buggy shell.
The injected patch changes the array layout and the display loop, so it drops or mangles entries.

- clean: `IntegrityCk 1 3 8 [3,2,1]` and `IntegrityCk 1 1 8 [1]`
- buggy: `IntegrityCk 1 3 8 [3,2]` and `IntegrityCk 1 1 8 ]`

The last root page is dropped from the list, and a one-element list renders as an empty `]`.
