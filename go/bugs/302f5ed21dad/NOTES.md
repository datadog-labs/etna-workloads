repro.go assigns to a constant with `x += 1` and `x++` (issue 52401).
Clean: reports "cannot assign to x" errors. Buggy: internal compiler error "panic: nil node",
because overflow() calls opPos on an operand with a nil expr, and the nil case was removed.
