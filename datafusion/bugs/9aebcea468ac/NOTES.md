repro.sql runs `date_bin` with an extreme `Timestamp(Second)` source (i64::MAX), once as a constant and once through a VALUES array.
df-buggy panics with "attempt to multiply with overflow" (exit 101) while scaling seconds to nanoseconds.
df-clean exits 0 and prints NULL for both queries.
The two builds differ in output and exit status.
