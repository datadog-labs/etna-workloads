Reproducer (repro.sh, tkt3810-3..6): connection A loads the schema, connection B drops t1,
then A creates a TEMP trigger on the now-missing t1 (orphan trigger).
Clean: the CREATE succeeds, the trigger r1 is listed in temp.sqlite_master, and DROP TRIGGER r1
gives "no such trigger: r1".
Buggy: the orphan flag is never set, so A fails with "malformed database schema (r1) - no such table: t1"
on the CREATE and on every later statement.
