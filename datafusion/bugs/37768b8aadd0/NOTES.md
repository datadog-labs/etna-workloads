repro.sql runs bounded sliding-window queries (ROWS 1 PRECEDING) over data with a NULL gap.
- covar_pop/covar_samp/corr: clean returns results; buggy errors with "retract_batch is not implemented".
- var_pop/var_samp/stddev_samp: clean returns 25/50/7.07 at row 5; buggy returns NaN, because retracting the last valid row divides by zero.
