repro.go is the issue79887 test program (add/sub using bits.Add64/Sub64 with a carry from `p < q`), plus a main that prints results.
Clean: compiles and prints results. Buggy: internal compiler error "InvertFlags should never make it to codegen" in `sub`, since the ADCQ/SBBQ rules that absorb InvertFlags are missing.
