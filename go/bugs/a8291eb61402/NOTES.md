Reproducer: `var x = new(0); var y = x` at package level (regression test for go.dev/issue/77237).
staticcopy treats `&autotemp` as a global; with the fix removed, the compiler hits an ICE in
staticdata.GlobalLinksym. The clean toolchain compiles and prints 0.
