repro.sql runs LEAD(x, 2) and LEAD(x) over an ordered ROWS-frame window with LIMIT 3 on a 6-row table.
Clean: correct values (30,40,50 / 20,30,40). Buggy: the limit is pushed into the sort as TopK without
accounting for LEAD's lookahead, so trailing rows come back NULL (30,NULL,NULL / 20,30,NULL).
