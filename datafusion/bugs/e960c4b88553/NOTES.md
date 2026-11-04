`repro.sql` runs CTAS and CREATE VIEW over a self-join (`t x JOIN t y`), which gives duplicate unqualified column names (`column1`, `column1`).
Clean build: the CREATE is rejected with "duplicate unqualified field name column1", so the later SELECT reports the table or view as not found.
Buggy build: the duplicate-name check is missing. The error message changes to "duplicate qualified field name s.column1", and it comes from the SELECT, not the CREATE. The table or view is already registered but can't be read. Exit status is 0 in both builds.
