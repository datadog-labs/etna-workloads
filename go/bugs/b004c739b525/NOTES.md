repro.go calls generic `g[T any](x, y T)` with a `string` and a named `S` (underlying string) in both orders.
Clean toolchain: named types are preferred during inference, so `g(s, m)` reports the error at `s` (T inferred as S).
Buggy toolchain: unify keeps the unnamed type, so `g(s, m)` infers string and the error is reported at `m` instead (different column and message).
Both toolchains fail to compile with exit status 1, but the diagnostics differ.
