Reproducer for Go issue #77597 (`repro.sh`). It writes a hello-world `main.go` and runs `go run -trimpath -race '-gcflags=all=-N -l' main.go`.

- go-clean: prints `OK`, exit 0.
- go-buggy: the compiler adds racefuncenter/racefuncexit to generic functions from NoRaceFunc packages (e.g. `atomic.(*Pointer[T]).Store`). The program segfaults during early runtime init, before the race runtime is ready (SIGSEGV, exit status 2).
