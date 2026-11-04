repro.sql runs `date_bin(interval '1637426858 months', to_timestamp_millis(1040292460), timestamp '1984-01-07')` (from issue #20219).
Clean build: returns NULL, exit 0. Buggy build: panics ("`DateTime - Months` out of range"), exit 101.
