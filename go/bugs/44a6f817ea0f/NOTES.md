repro.sh compiles a small function (the issue 71228 pattern) with `go tool compile -S` and prints the
write-barrier calls. Clean: two separate gcWriteBarrier1 calls (g1=nil, g2=nil) then wbMove.
Buggy: the two global stores are coalesced into one gcWriteBarrier2 before wbMove, so the non-WB store
`sp.c = ptr` is no longer ordered before the wbMove that reads it.
The difference is in generated code only. The real miscompile needs a GC cycle at exactly the wrong
moment and is unreliable (upstream says so too); my GC-stress runtime attempt did not fail.
