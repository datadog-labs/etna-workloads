repro.go is the upstream issue42032 test, with println instead of panic. It appends T{&y, &z} to a slice, where y is a not-in-heap type (embeds cgo.Incomplete), then checks that field x was stored.

- go-clean: prints nothing, exit status 0.
- go-buggy: storeType drops the store of the not-in-heap pointer, so it prints "pointer not written", exit status 0.
