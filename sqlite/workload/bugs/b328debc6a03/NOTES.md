Self-referencing FK: `t4(a UNIQUE, b REFERENCES t4(a))`; inserting `(NULL, 1)` must fail
("FOREIGN KEY constraint failed") since no parent row has a=1. With the bug, the row
is compared to itself with NULL-comparison not jumping, so the self-match check
wrongly passes and the insert succeeds silently (clean shell reports the error).
