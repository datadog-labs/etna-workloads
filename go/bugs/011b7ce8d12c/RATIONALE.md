# Rationale

Changed `tree/src/cmd/compile/internal/types2/under.go` (`commonUnder`, channel case) back to the pre-fix logic. This reverses the types2 hunk of fix.patch:

    if chu.dir == SendRecv { ct, cu = t, u } else if chu.dir != ch.dir { conflict error }

The fix's `switch` skips equal directions, switches to the restricted channel when `chu.dir == SendRecv`, and reports a conflict only if `ch.dir != SendRecv`. The old code reports a conflict whenever the directions differ and the earlier channel is not bidirectional. So `chan int | chan<- int` is wrongly rejected as conflicting. go/types is not touched because the task limits changes to src/cmd/compile/.

Failing oracle cases: `TestFixedbugs` and `TestFixedbugs/issue72936.go` in types2. They fail with spurious "conflicting directions" errors for `chan int | chan<- int` and `chan int | <-chan int`.
