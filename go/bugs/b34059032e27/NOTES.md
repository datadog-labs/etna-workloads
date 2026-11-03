repro.go calls generic `f[S any](S)` with invalid arguments (`s.y`, `1 / s`).
Clean toolchain reports only the argument errors. Buggy toolchain (infer no longer
returns early on invalid args) also reports spurious "in call to f, cannot infer S" errors.
