`repro.sql` is rowvalue9-3.6. Table c1(a INTEGER, b TEXT) holds (1,1) and c2(x BLOB, y BLOB) holds (1,1). The query is `SELECT c1.rowid FROM c1 WHERE (a, b) = (SELECT x, y FROM c2)`.

The affinity of the sub-select row-value element (y, BLOB) should be applied to the comparison with b (TEXT). Since BLOB has no conversion, '1' does not equal the blob 1, so the correct result is empty.

- clean: no rows.
- buggy: prints `1`, because the sub-select element's affinity is ignored.
