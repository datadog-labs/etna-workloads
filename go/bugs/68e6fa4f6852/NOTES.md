repro.go is the upstream test for issue 43444 (package-level variable initialization order).
Clean toolchain prints `e a b c d`; the buggy one prints `d e a b c`, because the init task is built after
deadcode removal, which drops the `if false { _ = z }` reference to z, so d no longer depends on z and initializes too early.
