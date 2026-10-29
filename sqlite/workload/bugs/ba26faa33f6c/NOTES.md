repro.sql joins generate_series with itself (CROSS JOIN, so the outer loop is fixed) and puts an IN
constraint on the outer table's `stop`. Inner loop's xBestIndex args reuse temp registers.
With the bug, the temp registers holding the outer vtab's constraint args are released and
reused by the inner vtab, clobbering the IN loop's value.
Clean: 1|1, 2|2, 1|1, 2|2, 3|3. Buggy: 1|1, 2|2, 2|2, 3|3 (rows missing/wrong).
