repro.go declares a channel whose element type (`[1<<17]byte`) exceeds 64kB, so compilation fails with "channel element type too large".
Clean toolchain reports the error with a position (`./repro.go:5:5: ...`); the buggy one (setBasePos removed in noder reader) prints it with no file:line prefix.
