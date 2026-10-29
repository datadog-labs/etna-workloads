Reproducer (repro.sql): the test's SQL (page_size=512, 74 rows of 400-byte blobs, AFTER INSERT trigger on x=74 that deletes all rows and reinserts 75, 76), ending with a count/min/max query.
Clean: `2|75|76`. Buggy: "database disk image is malformed" on the final INSERT (invalid cursors keep page references), and the table keeps 73 rows.
