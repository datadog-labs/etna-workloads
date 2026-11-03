repro.sh compiles a package directly with `go tool compile` containing an array literal of structs
with interface conversions (`[...]T{{a: x, ...}, {a: s}}`).
The injected bug skips the walk pass on the generated init statements in fixedlit, so
clean compiles fine (exit=0); buggy fails with `internal compiler error: 'f': unhandled expr CONVIFACE`.
(Using `go run` instead makes buggy crash while building the runtime, with a fresh build cache.)
