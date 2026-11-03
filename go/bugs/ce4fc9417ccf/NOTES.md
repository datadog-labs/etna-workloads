repro.go is the upstream test issue79274.go. Nested inlined calls of a closure `fnc`, which contains its own closure, are all on one source line. The buggy hash of the inline call stack uses name:line:col, so it can collide.
go-clean compiles and runs it with exit 0 and no output. go-buggy fails to compile with "symbol main.F.func1.func1#...# redeclared".
