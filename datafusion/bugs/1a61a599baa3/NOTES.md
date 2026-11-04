repro.sql runs `date_bin` with a 1ns stride, source = i64::MAX and origin = i64::MIN (nanosecond timestamps), so source - origin overflows i64.

- df-clean: returns NULL, exit status 0.
- df-buggy: panics at date_bin.rs:327 ("attempt to subtract with overflow"), exit status 101.
