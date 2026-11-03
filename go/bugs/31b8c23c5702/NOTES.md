repro.go is issue53600 (prove/loopbce with `i <= MaxInt64`) with a bounded iteration guard.
Clean: each loop wraps past MaxInt64, sees i<0, prints "done" and exits.
Buggy: loopbce treats the `<= MaxInt64` loop as an induction variable that cannot overflow, so `i < 0` is folded away and the loop never terminates naturally. The guard prints "runaway" (and shows negative values in g/h).
Run: `go run -trimpath repro.go` (output on stderr via println).
