Window sum() over REAL values with a sliding frame (ROWS 2 PRECEDING).
The buggy sumInverse adds instead of subtracts the departing row's value.
Clean: 10.0, 30.0, 31.0, 24.0, 104.0; buggy gives wrong sums once rows leave the frame.
