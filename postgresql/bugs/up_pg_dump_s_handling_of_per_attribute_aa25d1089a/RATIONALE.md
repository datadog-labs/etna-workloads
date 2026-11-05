# Rationale

File/function: src/bin/pg_dump/pg_dump.c, dumpTableSchema().

Traces to the fix.patch dumpTableSchema hunks. The fix removed the inline
" COMPRESSION x" clause from the CREATE TABLE column definition and instead
emitted `ALTER TABLE ONLY ... ALTER COLUMN ... SET COMPRESSION`. I reversed that:
- Re-added the inline "Attribute compression" block (guarded by
  !no_toast_compression) in the column definition, before the print_default block.
- Removed the per-column ALTER ... SET COMPRESSION block from the later column loop.

Effect: CREATE TABLE (and the matview) embeds per-column COMPRESSION, which the
fix removed. The expected output is the ALTER form, so the tests fail.

I did not restore the TOASTCOMPRESSION archive entry. The current code has no
default_toast_compression handling, so those hunks have nothing to attach to.

Failing oracle cases (in every run mode that includes them, e.g. binary_upgrade,
clean, clean_if_exists, compression_*):
- "should dump CREATE TABLE test_table"
- "should dump CREATE TABLE test_compression"
- "should dump CREATE MATERIALIZED VIEW matview_compression"
