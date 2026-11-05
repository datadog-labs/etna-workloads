# Rationale

Changed: src/bin/pg_dump/common.c, flagInhAttrs() (traces to the common.c hunks of fix_impl.patch).
- Removed the `allNotNullsInvalid` variable and the per-parent tracking that clears it when a parent has a valid NOT NULL.
- Removed the `if (remoteVersion >= 180000 && allNotNullsInvalid) notnull_islocal = true;` step.

Effect: when a child's validated NOT NULL is inherited from parents that all have it NOT VALID, pg_dump no longer prints the constraint in the child. The restored child then inherits the NOT VALID constraint and the validated state is lost or the restore fails. The notnull_invalid field and its bookkeeping in pg_dump.c/pg_dump.h are left in place but are now unused. They are harmless, and the common.c change alone reintroduces the bug.

Failing oracle cases: 10061 of 13809, mostly in src/bin/pg_dump|t/002_pg_dump.pl (for example the "test_schema_plus_large_objects: should not dump ..." cases). The full list is in logs/oracle.log.
