repro.sh compiles three functions that zero a *[10]int via `for i := range p { p[i] = 0 }`
(plain pointer and field pointer, with and without explicit deref) using `go tool compile -S`
and prints each function's STEXT size.
The bug (injection in walk.arrayRangeClear) stops the range-clear idiom from being turned into
a memclr when the indexed operand is an ODEREF, so the buggy compiler emits a different
(1 byte smaller here) code sequence; the sizes differ between toolchains. There is no
wrong-output behaviour: only codegen quality is affected.
