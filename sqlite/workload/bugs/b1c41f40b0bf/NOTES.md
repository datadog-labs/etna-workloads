`repro.sql` creates an fts4 table with one row ('0zero'), an fts4aux table over it, and queries `WHERE term >= 5`.
The integer constraint must be treated as if term had blob affinity, so the clean shell returns both `0zero` rows.
The buggy shell passes the integer to the term scan as text "5", so the scan starts at "5" and returns no rows.
