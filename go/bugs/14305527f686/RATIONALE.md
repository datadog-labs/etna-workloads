# Rationale

Fix hunk (order.go, `Order.stmt`, OSELECT recv case): changed the condition `r.Right.Left.Op != ONAME` to `!IsAutoTmp(...)`, so the channel operand of a receive clause is copied to a temporary unless it is already a compiler temp.

In go1.27.3 the code is `src/cmd/compile/internal/walk/order.go`, case `ir.OSELRECV2`. I changed `!ir.IsAutoTmp(recv.X)` back to `recv.X.Op() != ir.ONAME`. A bare variable channel (`<-ch`) is then not copied, so it is read after the other clauses' expressions (e.g. `f()` in a send clause) have run, breaking the spec's in-order evaluation of select clauses.

Oracle: test/fixedbugs/issue43111.go fails. `ch` is set to nil by `f()` before the select reads it, so the select deadlocks ("all goroutines are asleep").
