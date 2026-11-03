repro.go is test/fixedbugs/issue72860.go. f(nil,false) must nil-panic on `*p`, but with the bug the
SSA tighten pass moves the nil check into a conditionally executed block, so the panic is skipped.
Clean: no output, exit 0. Buggy: prints "should have panicked".
