Sets x=0 and runs `DECRBY x -9223372036854775808` (LLONG_MIN).
Clean: error "decrement would overflow", x stays 0.
Buggy: -LLONG_MIN overflows back to LLONG_MIN, so the command succeeds and returns -9223372036854775808 for x.
