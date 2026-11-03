repro.sh: module with `go 1.22` and a file with `//go:build go1.19` that uses a slice-to-array conversion (Go 1.20 feature).
Clean: downgrades below go1.21 are ignored, so it compiles. Buggy: the downgrade is honored and the compiler reports "requires go1.20 or later".
