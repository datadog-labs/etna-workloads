repro.sh compiles a file containing `for range 10 {}` with `-gcflags=-lang=go1.21`.
Clean toolchain: reports "cannot range over 10 (untyped int constant): requires go1.22 or later".
Buggy toolchain: the version check for range-over-int is removed, so it compiles silently (exit 0).
