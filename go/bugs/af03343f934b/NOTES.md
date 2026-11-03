repro.go indexes a slice with constant index 1 (variable length 1) inside a loop, with the
slice passed as a later argument so its length is not in AX, then recovers and prints the panic.
Clean: "index out of range [1] with length 1". Buggy: "... with length 56" (the value of AX, a*b),
because the amd64 LoweredPanicBoundsCR case shadows yVal, so the PCDATA names register AX
instead of the register holding the length.
Note: the go build cache is shared between the toolchains (same version string), so a stale cache
can hide the difference; check.sh gives the expected diff.
