Reproducer: ILIKE / NOT ILIKE with a wildcard-free pattern on a small table.
The buggy build simplifies `s ILIKE 'p1'` to `s = 'p1'`, so it drops 'P1' (and NOT ILIKE wrongly keeps it). The clean build matches case-insensitively.
