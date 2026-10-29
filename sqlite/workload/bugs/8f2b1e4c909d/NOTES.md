Creates a table with a partial index `WHERE c0 NOT NULL`, inserts a row with c0 NULL, then queries `WHERE c0 IS NOT 1`.
Clean shell returns `|row`. Buggy shell returns no rows, because the theorem prover wrongly treats `IS NOT` as implying c0 NOT NULL and scans the partial index, which lacks the row.
