repro.sql runs NTILE(4) over 10 rows, plus NTILE(3) over 7 rows as a control.
NTILE(4) over 10 rows differs between the builds. The clean build gives bucket sizes 3,3,2,2, with the larger buckets first as the SQL standard requires. The buggy build uses the interpolation formula `i * n / rows` and gives 3,2,3,2.
The NTILE(3) over 7 rows query gives the same output on both builds (3,2,2).
