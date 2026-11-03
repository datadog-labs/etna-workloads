repro.sh compiles a package (via `go tool compile`) with dynamic initializers for blank composite variables (`var _ = [2]*int{nil, f()}`, etc.; issue 43677).
Clean: compiles, exit 0. Buggy: internal compiler error "cannot take offset of nil, blank name or non-global variable: _", exit 2.
