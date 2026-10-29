Reproducer (repro.sql): LEFT JOIN with ON clause on a column of a flattened subquery (`SELECT * FROM y1`), where x=0 so the ON is false.
Clean: returns the row `0|0|1|` and count(z)=1. Buggy: the flattened ON term loses its EP_FromJoin flag, so the row is dropped (no row from the first query, count(z)=0).
