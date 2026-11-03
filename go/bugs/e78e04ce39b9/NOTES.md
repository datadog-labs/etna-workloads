repro.sh writes the test from issue44378 (two type-switch bindings `x` on one very long line, so they share name/file/line/col) and builds it.
go-clean builds fine. go-buggy hits `internal compiler error: child dcl collision on symbol x` in DWARF gen (dwinl.go makePreinlineDclMap).
