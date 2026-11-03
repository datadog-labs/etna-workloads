repro.sh writes the upstream issue61992 test program and compiles it with `go tool compile`.
Clean toolchain: compiles fine (exit 0). Buggy toolchain: internal compiler error
"startMem[b2] has different values" from expandCalls using the wrong block (a.Block instead of v.Block) for mem decomposition.
