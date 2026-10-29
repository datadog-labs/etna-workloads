repro.sql runs the fts5secure-6.0 case: with secure-delete on, insert a row (rowid 3407) with repeated tokens, delete it, then run integrity-check.
Clean shell: no error, exit 0. Buggy shell: "fts5: corruption found reading blob ... from table "fts"" and exit 1, because the buggy secure-delete page-index rewrite writes wrong offsets.
