Reproducer (repro.sql): a BEFORE UPDATE trigger deletes the row being updated (triggerC-7.3).
Clean: the row stays deleted, t7 = 3|4, 5|6, and t8 is empty.
Buggy: the missing NotExists check after the BEFORE trigger means the deleted row is still updated/re-inserted, and the AFTER trigger fires.
