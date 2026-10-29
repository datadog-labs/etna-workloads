percent_rank() over a single-row partition must return 0.0. The injected bug returns 100.0 instead.
repro.sql runs this on a one-row table: clean prints 0.0, buggy prints 100.0.
