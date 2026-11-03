repro.go is test/fixedbugs/issue60601.go plus a final println("ok").
It uses 1 / unsafe.Sizeof(*new(T)) in a generic function, instantiated with [0]byte.
Clean: compiles, the division panics at run time as expected, and the program prints "ok" (exit 0).
Buggy: typecheck reports "division by zero" at compile time (with a "panic traversed funcBody" line) and exits 1.
