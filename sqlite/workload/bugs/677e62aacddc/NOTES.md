repro.sql runs the notnull2-3.1 query: `SELECT * FROM t0 WHERE ((c0 NOT NULL) AND 1) OR (c0 == NULL)` on a one-row table (c0=0).
Clean shell returns the row `0`; the buggy shell combines the disjuncts despite the TERM_VNULL flag and returns no rows.
