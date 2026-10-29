repro.sql runs the join-19.3 and join-19.5 queries: a LEFT JOIN against an empty table filtered by `(b IS NOT NULL) IS NOT NULL`.
Clean shell returns the row `0|`; the buggy shell wrongly infers b is non-NULL, turns the LEFT JOIN into an inner join, and returns no rows.
