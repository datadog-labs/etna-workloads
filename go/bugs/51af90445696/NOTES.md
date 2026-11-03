repro.go: `const s float32 = 0; var x = 0 << s` (the upstream issue56425 case).
The shift count is a typed float constant. types2 should read the count from the
ToInt-converted value (`yval`), but the injected bug uses `y.val`.
go-clean compiles and runs, printing 0. go-buggy crashes with
"internal compiler error: panic: 0 not an Int" (exit status 1).
