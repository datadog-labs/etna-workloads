`repro.go` stores a pointer through a `**T` (write-barrier store), then computes `uint64(len(*sp)) / 7`
and stores it. Division by 7 is expanded to `Avg64u(x, Hmul64u(x, magic))`, where `x` is the
(decomposed) string-length load that sits after the write-barrier store.

With the bug, `storeOrder` (schedule.go) pushes all unvisited args with `continue` instead of
stopping after the first (`break`), so `Hmul64u` is visited while `x` is still pending and gets
store number 2. It is ordered before the write-barrier store while its operand `x` is after it, so
the write-barrier pass splits the block wrongly and the division reads a bad value.

go-clean prints `4`; go-buggy prints garbage (e.g. `96660`).
