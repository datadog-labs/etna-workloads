repro.sh compiles a small file with `b.Loop()` using `-gcflags=-m=2` and prints the "kept alive"/"escape" diagnostics.

The fix stopped the compiler from wrapping bloop's keep-alive arguments in an interface conversion. The buggy toolchain still does that conversion. It prints extra escape diagnostics, such as `(interface {})(localsink) does not escape`, that the clean toolchain doesn't print.
