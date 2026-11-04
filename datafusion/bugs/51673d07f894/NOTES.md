Reproducer for the timestamp unit coercion bug (fix: prefer the finer unit when mixing Timestamp units).

repro.sql compares, subtracts and UNION ALLs a Timestamp(Second) value with a Timestamp(Millisecond) value that has a .123 fractional part.

- df-clean coerces to ms. `=` is false, `<` is true, the difference is 0.123 secs, and the UNION column is Timestamp(ms) with both rows kept distinct.
- df-buggy coerces to the coarser second unit. This drops the fraction, so `=` is true, `<` is false, the difference is 0 secs, and the UNION column is Timestamp(s) with both rows showing 00:00:00.
