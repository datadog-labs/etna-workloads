repro.sql reproduces windowE-5.2: a sliding-window sum(x) over rows -1, 9223372036854775807, 1, 0.5.
When removing a row (sumInverse) causes int64 overflow, the buggy shell doesn't switch properly to
Kahan-Babuska summation. Clean prints 9.2233720368547758e+18, 1.5, 0.5 for ids 2-4; buggy prints
0.5, -9.2233720368547758e+18, -9.2233720368547758e+18 (wrong results).
