# Reintroduced bug: inlining discards callee-expression side effects (#42703)

Fix hunk: in `mkinlcall`, for OCALLFUNC, preserve side effects (init / OCONVNOP inits) of the callee expression `n.Left`.

In go1.27.3 that logic exists twice:

1. `noder/reader.go` `unifiedInlineCall`: `inline.CalleeEffects(&init, call.Fun)` (descendant of the fix hunk). **Removed** the call (and the now-unused `inline` import). Pre-fix code simply did not take the callee's init/inlined-call body.
2. `typecheck/func.go` `tcCall`: `RewriteNonNameCall(n)` hoists a side-effecting callee (`f()()` -> `t := f(); t()`) into the call's init, so the inliner never sees side effects in `Fun`. This is the same defect covered a second way (the fix's "callee may contain side effects added by addinit" case), so with only (1) reverted the test still passes. **Removed** that call too (function left in place, unused).

With both reverted, `f()()` where `f` is inlined and returns an inlinable `g` yields `Fun = OINLCALL`; inlining `g` drops `f`'s body (`ok[0] = true`), as in #42703.

## Oracle
`test/fixedbugs/issue42703.go` (and the enclosing `TestShouldTest`) fail. The failure shows up as internal compiler errors while building std for the testdir run (e.g. `value strings.s incorrectly live at entry`), because the dropped inlined bodies also lose variable definitions; it is not the quiet `panic("FAIL")` of the original test, which can't be reached since std fails to build first.
