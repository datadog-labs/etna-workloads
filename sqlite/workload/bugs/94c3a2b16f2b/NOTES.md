Inserts out-of-int64-range numeric strings (-9223372036854775809, -9223372036854776832, 9223372036854775808) into a NUMBER-affinity column and prints value and typeof.
Clean: all stored as real (±9.2233720368547758e+18). Buggy: compare2pow63 is wrong, so they are stored as integer, clamped to -9223372036854775808 / 9223372036854775807.
