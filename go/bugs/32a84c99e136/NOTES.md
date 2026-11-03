repro.go is test/fixedbugs/issue40629.go. It has open-coded defers, a deliberate nil-pointer panic, and an infinite loop after the panic so the return is unreachable. A defer then grows the stack, which forces a stack copy.

- go-clean: exits 0 with no output. The open-coded defer arg slot is live everywhere, so it is adjusted during the stack copy.
- go-buggy: the slot is not marked live, so it is not adjusted. The first defer sees a corrupted stack variable or crashes, and the program exits 1 with a runtime crash dump.
