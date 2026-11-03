Reproducer: repro.go uses type-parameter constraints `~A` / `~B` where A and B are aliases
(`[4]int`, `map[string]interface{}`), then calls len/cap, a composite literal, and indexes a type assertion.

Clean toolchain: compiles and runs, printing "8 4" and "1".
Buggy toolchain: underIs no longer unaliases tilde terms, so the compile fails with
"invalid argument ... for built-in len/cap", "invalid composite literal type V" and "cannot index a.(W)".
