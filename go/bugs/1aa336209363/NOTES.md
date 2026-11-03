repro.sh compiles the test/tailcall.go program with -d=tailcall=1. Clean compiler only emits a tail call
for the non-inlineable Get2Vals wrapper; the buggy one also emits one for the inlineable Get3Vals wrapper
(extra diagnostic, and possibly a different compile result).
