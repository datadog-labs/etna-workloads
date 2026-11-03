repro.go is the upstream test issue78892.go. g calls f(1) in a loop; f returns early when x==1, otherwise computes 7/(x-1).
Buggy toolchain: the injection marks the divide ops as earlyOk, so the loop-invariant divide is hoisted above its divisor==0 check. With x==1 it faults (SIGFPE, panic: integer divide by zero, exit 2).
Clean toolchain: the divide stays under its check, and the program exits 0 with no output.
