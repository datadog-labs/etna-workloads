# Rationale

Fix hunk: in `regalloc.go`, after allocating `tmpReg` and adding it to `s.nospill`, the fix also adds it to `s.tmpused`.

In go1.27.3 the code is `s.nospill = s.nospill.addReg(tmpReg)` followed by `s.tmpused = s.tmpused.addReg(tmpReg)` (regalloc.go, around line 1870). I removed the `s.tmpused` line, which restores the pre-fix code. Without it, the later move of an output-register occupant (the `allocValToReg` path at line 548, which excludes `s.tmpused`) can pick the temporary register, so the temp and the displaced value share a register.

Oracle: `test/fixedbugs/issue71857.go` fails. The atomic `Or` result is clobbered, and `f` crashes with a nil-pointer SIGSEGV at addr=0xaaa, which is the Or mask used as a pointer. `TestShouldTest` still passes.
