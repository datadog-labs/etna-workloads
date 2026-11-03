repro.go declares `type T [1<<31]byte` and a function taking `map[int]T` that indexes it.

go-clean reports the normal error `map element type too large` (exit 1).
go-buggy hits `internal compiler error: map elem too big 2147483648` in reflectdata.ZeroAddr (exit 1), because the size check in types.CalcSize for TMAP is missing.
