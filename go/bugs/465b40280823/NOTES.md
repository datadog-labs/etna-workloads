repro.sh compiles a function (from test/inline.go `o`) with `-gcflags="-m -d=inlfuncswithclosures=1"`.
A closure inside an inlined closure body should have its "func literal does not escape" diagnostic
reported at the inlined call site (x.go:9:3). The buggy toolchain keeps the closure's original
position and reports it at x.go:7:10 instead.
