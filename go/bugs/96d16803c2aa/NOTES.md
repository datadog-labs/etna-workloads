repro.go is upstream test/fixedbugs/issue60582.go: it passes min(a, b) and max(a, b) as call arguments to fmt.Println.

- go-clean prints 5 and 7 and exits 0.
- go-buggy fails with "internal compiler error: mayCall" and exits 1. The injection removes OMIN/OMAX from walk.mayCall, so those ops hit its default Fatalf case.
- With a fresh build cache, the crash happens while compiling package runtime (runtime/mspanset.go:338, `max(cpu.CacheLineSize, 512)`), before the user's file is compiled. Compiling the user file alone also hits it (t.go:13).
