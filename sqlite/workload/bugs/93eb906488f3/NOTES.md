repro.sql: an INSERT with two ON CONFLICT clauses; the second has an unresolvable symbol in its target (`SELECT t2 FROM nosuchtable`).

Clean shell: "Parse error: no such table: nosuchtable", exit 1.
Buggy shell: the error from sqlite3UpsertAnalyzeTarget is ignored, so analysis continues and hits assertion `pTab!=0 && pTab->zName!=0` in lookupName (abort, exit -6).
