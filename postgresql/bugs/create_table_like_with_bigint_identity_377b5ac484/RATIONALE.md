# Rationale

Hunk: src/backend/commands/sequence.c, `sequence_options()`; traces to the sole hunk of fix_impl.patch.
The fix used makeFloat() (as gram.y does) for the 64-bit cache/increment/maxvalue/minvalue/start options. This change reverts them to makeInteger(), which takes an int. The int64 values are truncated, so CREATE TABLE ... LIKE ... INCLUDING IDENTITY copies a wrong identity sequence for bigint columns.

Failing oracle case: src/test/regress||create_table_like
