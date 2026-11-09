Input: an arrow function assigned to a const that returns a self-call in one branch and `0` otherwise, under strict.
Clean: no diagnostics (exit 0). Injected: reports TS7023 implicit any return type for 'fn1' (exit 2).
