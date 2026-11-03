Compiles the upstream test (package p) for issue 78297 via `go build`. Nested generic
instantiation G[T]()/H[T]() with T ~*[1]byte, then slicing the result.
Clean: compiles, prints "exit 0". Buggy: internal compiler error
"bad ptr to array in slice go.shape.*uint8".
