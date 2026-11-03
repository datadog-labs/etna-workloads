repro.sh writes a small program (nested closure inside an inlined func literal, from test/inline.go) and builds it with `-gcflags=-m`.
Clean: succeeds, prints inlining diagnostics. Buggy: the compiler hits an internal compiler error ("oldBase ... already has inlining index") while building the runtime package, so the build fails with exit status 1.
Cause: injection removes suppressInlPos around reading a closure signature, so the closure body gets inline-adjusted positions.
