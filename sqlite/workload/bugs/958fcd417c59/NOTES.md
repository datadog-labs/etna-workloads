repro.sql runs the join8-22020 query: `t1 JOIN t3 ON (b=TRUE) RIGHT JOIN t2 ON TRUE WHERE (b IS TRUE)`, with one row in t2 and t1 and t3 empty.
Clean shell returns no rows. Buggy shell returns one row (`|||`), because constant propagation wrongly applies through the inner ON clause when a RIGHT JOIN is present.
