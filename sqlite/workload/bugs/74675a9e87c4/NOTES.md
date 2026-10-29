repro.sql: makes a UTF-16le database, stores a 5000-char 'a' blob (10000 bytes, spills to overflow pages at 1024-byte pages), then selects length(CAST(c AS TEXT)).
Clean: 5000|10000|5000. Buggy: 5000|10000|1, because the BLOB read from an overflow page gets the wrong encoding, so the cast to TEXT is not converted correctly and the length is wrong.
