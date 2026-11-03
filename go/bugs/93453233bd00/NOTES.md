`repro.go` is the upstream issue48536 test with the pointer printing replaced by fixed messages.
It calls `unsafe.Add` with a `uint8` offset (`uint8(i)` and a `uint8` variable).

- go-clean: prints nothing and exits 0.
- go-buggy: prints two FAIL lines and exits 0. The offset is not widened to uintptr, so garbage upper register bits are added to the pointer.
