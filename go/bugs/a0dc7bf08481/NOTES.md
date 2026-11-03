repro.sh writes the issue73823 test program and compiles it with `go tool compile -p p`.
Clean toolchain compiles it fine. Buggy toolchain (loopvar.go no longer sets z.Defn = as) hits
an internal compiler error: "next missing from LHS of .autotmp_N, _ := ..." in ReassignOracle.
