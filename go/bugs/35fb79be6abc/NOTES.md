repro.go uses unions whose terms are interface types (`T1 | T1`, `T1 | T2`).
Per the spec only non-interface terms must be disjoint. The clean toolchain
compiles and prints "ok". The buggy toolchain runs the overlap test on interface
terms too and reports "overlapping terms" compile errors.
