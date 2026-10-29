Reproducer for window8-4.5.2: RANGE frame with `ORDER BY a DESC NULLS FIRST` and `10 FOLLOWING`.
The injected bug jumps over the NULL-handling in windowCodeRangeTest, so NULL rows skip the early goto.
Expected (clean) result: 6 6 6 15 15. The buggy shell gives different sums (see ./check.sh).
