repro.go is the issue78641 test program. With the bug, go-buggy hits an ICE ("expecting positive value") in loopbce when the loop step is minInt; go-clean compiles and runs it with exit 0.
