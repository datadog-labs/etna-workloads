# Rationale

Changed: `src/bin/pg_dump/common.c`, `flagInhAttrs()`.

Traces to the fix.patch hunks in `flagInhAttrs` ("Remove generation expression from child" with
`foundGenerated && !binary_upgrade`). In current code that logic is the block
`if (foundSameGenerated && !foundDiffGenerated && !ispartition && !binary_upgrade) attrdefs[j]->dobj.dump = DUMP_COMPONENT_NONE;`.
I removed it. Inherited generated columns in child tables then keep their generation expression
as a dumpable object, so pg_dump emits it for the child (a separate/duplicate generation
expression that has no valid syntax), and restore of the dump breaks. This is the original bug.

## Failing oracle cases
10050 of 13808 oracle cases fail, almost all in `src/bin/pg_dump|t/002_pg_dump.pl`
(every run/restore and "should dump/not dump" case, since the dump or restore errors out).
