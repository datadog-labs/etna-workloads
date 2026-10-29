Reproducer (`repro.sql`): contentless fts5 table with secure-delete on, insert two rows with the same token, then a special 'delete' of rowid 2, then `pragma quick_check`.

Clean shell prints `ok`. Buggy shell prints `fts5: corruption found reading blob 274877906945 from table "xyz"`, because the integrity check wrongly reports the index as corrupt. Exit status is 0 on both.
