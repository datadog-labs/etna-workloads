repro.sql: adds a CHECK constraint via ALTER TABLE to a table with a row where the
expression evaluates to NULL (b!=5 with b NULL).
Clean: succeeds, schema shows the constraint. Buggy: "constraint failed" error, exit status 1,
constraint not added (the validity scan uses IS FALSE→IS NOT TRUE, rejecting NULL).
