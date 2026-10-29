Creates t0 with a NULL row and a partial index `WHERE c0 NOT NULL`, then runs the three BETWEEN queries from index6-15.2..4.
Clean shell returns rows 1, 2 and 3. The buggy shell wrongly treats `(c0 IS FALSE)` inside BETWEEN as implying c0 NOT NULL, so it uses the partial index and returns no rows.
