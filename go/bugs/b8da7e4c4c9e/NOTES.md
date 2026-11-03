repro.go is test/fixedbugs/issue49100.go. A labeled `for` loop in an inlinable function uses `continue loop`, and the caller has a loop with the same label.
In the buggy toolchain, break/continue labels are not translated when inlined, so `continue loop` targets the caller's loop. The output then differs (the loop is cut short or restarts). The clean toolchain prints the expected 12 lines.
