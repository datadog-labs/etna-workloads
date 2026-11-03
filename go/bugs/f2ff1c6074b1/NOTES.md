repro.sh compiles `go copy([]int{1: 0}, []int{})`. With the bug, the escape analysis
rewrite of slice-literal call arguments wraps the whole Key:Value element in a temp
instead of only the Value; the buggy compiler fails (see check.sh output), the clean one compiles fine.
