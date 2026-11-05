# Rationale

Changed file: src/backend/partitioning/partbounds.c, function get_qual_for_range().

Traces to the fix.patch hunk that rewrote get_qual_for_range() to build OR arms over all remaining key columns
(`num_or_arms = key->partnatts - i`) and to use GT/GE per arm.

1. `num_or_arms = 1` (was `key->partnatts - i`): only one arm is emitted, so the constraint checks only the
   first column whose bounds differ, like the pre-fix code that stopped at that column. Later columns are ignored.
2. Lower-bound strategy: the "last column" test `j == key->partnatts - 1` becomes `j - i == num_or_arms - 1`,
   so the single arm uses >= instead of >. Otherwise rows equal to the lower bound in that column would be wrongly excluded.

Result: for multi-column range partitions such as FROM (a1,b1) TO (a2,b2), the partition constraint is
`a >= a1 AND a < a2` and ignores b. The constraint is too weak, so the expected output changes in tests that print it.

Oracle cases that fail: src/test/regress||insert. (src/test/regress||inherit still passes.)
