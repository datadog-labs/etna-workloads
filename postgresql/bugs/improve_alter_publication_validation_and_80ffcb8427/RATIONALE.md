# Rationale

File: src/backend/commands/publicationcmds.c, function AlterPublicationTables.
Traces to the publicationcmds.c hunk of fix.patch. The fix replaced the ad-hoc
column-name-to-attnum loop with a call to pub_collist_validate(), so ALTER
PUBLICATION ... SET validated the column list. The edit restores the old loop,
which uses get_attnum() and does no validation. Unknown, system, generated and
duplicate columns are no longer rejected up front. An unknown column yields
InvalidAttrNumber in the bitmap, and the error messages differ from the fixed ones.
The other fix hunks (refactoring in pg_publication.c) were left alone because
the behavior change comes only from this hunk.

Failing oracle case: src/test/regress||publication
