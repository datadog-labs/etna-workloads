repro.sh compiles a file with a bodyless `func F()` and a `//go:noescape` func with a body, using `go tool compile -complete`.
Clean: reports "missing function body" and "can only use //go:noescape with external func implementations", exit 2.
Buggy: no diagnostics, exit 0.
