repro.go is test/fixedbugs/issue43480.go: a switch on a uint64 with large constant cases (1e0..1e19).
Clean: runs and exits 0. Buggy: switch case merging uses ir.Int64Val on constants above MaxInt64 (1e19), causing an internal compiler error.
