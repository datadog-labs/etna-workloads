Builds the issue56777 test program (package p, function `fn`) with `go build`.
The clean toolchain compiles it. The buggy toolchain (Phi-of-Not rewrite moves the phi into the wrong block) hits an internal compiler error ("panic during known bits ... index out of range") in `fn`.
repro.sh limits output to the first 5 lines, since the panic stack trace is long.
