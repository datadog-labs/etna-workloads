repro.go is upstream test issue43111 (select case ordering). A select with `case <-ch` and `case nilch <- f()` must evaluate f() (which closes and nils ch) before the receive reads ch.
Clean: exits 0. Buggy: the receive operand `ch` is not copied (bare ONAME), so it sees the nil ch, and the program dies with "fatal error: all goroutines are asleep - deadlock!" (exit 2).
