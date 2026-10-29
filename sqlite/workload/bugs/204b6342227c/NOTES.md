repro.sql: a table with a partial UNIQUE index (WHERE pid==1) and duplicate rows of 10.
`SELECT DISTINCT pid FROM person WHERE pid = 10` should return one row (10).
The buggy shell wrongly treats DISTINCT as redundant because of the partial unique index, so it returns 10 twice.
