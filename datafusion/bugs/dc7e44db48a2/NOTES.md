Reproducer for the UNION BY NAME bug (#15236). The script runs `UNION [ALL] BY NAME` on inputs
whose column count equals the result width but whose column order differs (`z, y, x` vs `x, y, z`).

The buggy build skips the wrapping `Projection` in that case. Columns are then matched by position
instead of by name, so one row comes back as `c b a` instead of `a b c`. The clean build returns
`a b c` for both rows.
