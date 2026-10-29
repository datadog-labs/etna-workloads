repro.sql runs the fkey2-20150416-100 statements. REPLACE into t1 triggers FK
action coding that hits a "foreign key mismatch" error. The fixed shell reports
that error; the buggy one doesn't propagate the rc to the parser, so the output differs.
