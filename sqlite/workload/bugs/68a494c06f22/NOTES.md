repro.sql: parent p1(x) has only a partial UNIQUE index (WHERE y<2); child c1 references p1(x).
Clean shell: `INSERT INTO c1 VALUES(1)` fails with "foreign key mismatch - "c1" referencing "p1"".
Buggy shell: the partial index is accepted as the parent key, so the insert silently succeeds.
