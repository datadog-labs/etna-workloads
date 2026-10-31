Creates a LogRecord with patched time.time_ns/time.time returning 1_677_902_297_100_000_000 ns (exactly 100 ms fraction) and prints record.msecs.
Clean: 100.0 (integer ns arithmetic). Buggy: 99.0 (float seconds truncation loses precision).
