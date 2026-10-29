Reproducer (repro.sql): create an fts3 table, add a trigger on its shadow table z1_content
(needs `.dbconfig defensive off`) whose body deletes from the virtual table, then DELETE FROM z1.

Clean: "SQL logic error" (statements inside fts3 are prepared with NO_VTAB, so the circular trigger fails cleanly).
Buggy: the prepare flags aren't propagated into the trigger sub-parse, giving "bad parameter or other API misuse",
then sqlite3_close() fails with unfinalized statements and a memory leak is reported.
