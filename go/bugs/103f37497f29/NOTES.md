`repro.go` is the upstream test for issue 58300. It calls `runtime.FuncForPC(reflect.ValueOf(fn).Pointer()).Name()` on `f` and on `g`. `g` is a frameless leaf function whose only body is an inlined call to `f`.

- go-clean prints `main.f` and `main.g`.
- go-buggy prints `main.f` twice. The first instruction of `g` comes from the inlined `f`, because the compiler no longer inserts a leading nop with a non-inlined position.
