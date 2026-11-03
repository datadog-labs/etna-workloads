repro.go is test/fixedbugs/issue71680.go (package changed to main, plus a trivial main).
It has mutually recursive closures: parserStateData and parserStateOpenMap each return a closure that calls the other.
go-clean compiles it and prints "ok" (exit 0).
go-buggy loops forever in the inliner, because the closure-parent recursion check is missing, so `go run` never finishes and the check times out.
