`repro.go` is a reduced form of test/fixedbugs/issue53600.go (`j`). The loop
`for j := MaxInt64; j <= i-1; j++` with i = MinInt64 has limit i-1 wrapping to
MaxInt64, so j wraps to negative after the first iteration.

The buggy compiler treats unit steps as never overflowing even for inclusive
(`<=`) comparisons, so it takes j as an induction variable with j >= 0 and the
`j < 0` check is proved false and removed. The loop then never exits (the
reproducer stops it after 4 iterations).

- clean: prints MaxInt64, then "wrapped", exit 0.
- buggy: prints MaxInt64 four times, then "runaway loop", exit 0.
