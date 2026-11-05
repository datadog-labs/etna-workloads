# Rationale
- File/function: src/backend/commands/tablecmds.c, CloneFkReferencing().
- Traces to the single hunk of fix_impl.patch. I removed the check that errors out when fk->confrelid == RelationGetRelid(partRel), so ATTACH PARTITION no longer refuses a table that the partitioned table already references by foreign key. The bug is back.

Failing oracle case: src/test/regress||foreign_key
