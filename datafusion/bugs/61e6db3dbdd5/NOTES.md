Reproducer: `var_samp`/`stddev_samp` with a FILTER, grouped, where one group has no rows passing the filter (count 0).
Clean build returns NULL for that group. Buggy build computes `count - 1` on an unsigned 0 in the variance GroupsAccumulator and panics ("attempt to subtract with overflow", exit status 101).
