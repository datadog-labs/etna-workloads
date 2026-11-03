repro.go is upstream test issue78303_1.go. It loops with i stepping by 1<<62 from -1<<63 up to a bound that is only known at run time.
Clean: the loop ends after 2 iterations, so a(2) is called and the program exits 0.
Buggy: the loop is wrongly inverted into a downward-counting loop and overflows. The result is wrong, so the program panics with "got wrong result" (exit 2).
