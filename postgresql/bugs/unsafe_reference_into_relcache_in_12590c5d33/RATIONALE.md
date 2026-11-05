# Rationale
File: src/backend/commands/tablecmds.c, function RebuildConstraintComment (CommentStmt construction for OBJECT_TABCONSTRAINT, ~line 15904).
Traces to the single fix.patch hunk (RebuildConstraintComment): pstrdup() of RelationGetRelationName(rel) and conname was added. I removed the pstrdup calls, so the CommentStmt holds pointers directly into the relcache entry (and conname), which dangle once the relcache entry is rebuilt/closed (use-after-free, visible under cache clobbering).

Failing oracle case: src/test/regress||alter_table
Observed failure: alter_table.out gets extra line: ERROR:  relation "public.?" does not exist
