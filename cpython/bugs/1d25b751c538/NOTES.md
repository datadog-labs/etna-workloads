Reproducer: a BufferedWriter over a raw object whose `closed` either raises ValueError or is NotImplemented (non-bool); calls write/flush/close and prints the outcome.
Clean: each call raises ValueError("test") / TypeError.
Buggy: the error from `closed` is swallowed (wrong "closed file" ValueError) and close() aborts with SystemError / fatal "returned a result with an exception set" (exit -6).
