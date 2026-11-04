repro.sql runs SUM(DISTINCT v) over a sliding ROWS 1 PRECEDING frame on a BIGINT column containing NULLs.
Clean build: NULL for all-NULL frames and NULLs skipped (1 NULL, 2 3, 3 3, 4 NULL, 5 5).
Buggy build: all-NULL frames return 0 and null slots' garbage values may be summed.
