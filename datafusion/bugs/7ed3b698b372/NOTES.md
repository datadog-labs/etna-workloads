repro.sql calls to_timestamp on a huge Decimal128(38,0) value (scalar, then array column).
Clean build: execution error "overflows timestamp nanoseconds", exit 0.
Buggy build: unchecked i128 multiply panics ("attempt to multiply with overflow"), exit 101.
