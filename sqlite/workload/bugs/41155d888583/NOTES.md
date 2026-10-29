repro.sql runs median() over 12 alternating values (0.1, 1.0) from a recursive CTE (the percentile-6.0 test).
With the bug, the pivot is the mean of three elements, which can fall outside the partition.
Clean shell prints 0.55. Buggy shell fails the assertion `iLt>0 && iLt<iGt` in percentSort and aborts (exit 134).
