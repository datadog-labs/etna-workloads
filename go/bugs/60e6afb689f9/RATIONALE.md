# Rationale

Hunk changed: `src/cmd/compile/internal/typecheck/expr.go`, `tcArith`.

It reverses the fix's only implementation hunk. The fix deleted the "division by zero" check for a constant integer divisor (ODIV/OMOD). I restored that check at the end of `tcArith`, where it was before the fix. I also re-added the `go/constant` import the check needs. The code is the same as before the fix.

With the check back, the compiler errors during typecheck on `1 / unsafe.Sizeof(*new(T))` once it is instantiated with `[0]byte`. The size is a constant 0 after shape instantiation. types2 had already accepted the expression, so it should have been a runtime panic.

Oracle result: `Test/fixedbugs/issue60601.go` fails. The compiler reports `issue60601.go:19:11: division by zero` and `panic traversed funcBody of div[go.shape.[0]uint8]`. The expected behaviour is that the program compiles and `div[[0]byte]()` panics with "divide by zero" at run time.
