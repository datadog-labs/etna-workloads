# Rationale

Fix (#46234): `inlsubst.closure` set `noPosUpdate` so the closure's own
declaration/body positions kept their original (non-inline-adjusted) src.Pos.
Without it the closure appears to have inlined calls, creating an inltree
for the closure and cycles in the inlining tree (infinite loop in traceback).

go1.27.3 has no `inlsubst`; inlining happens in unified IR
(`noder/reader.go`). The equivalent of `noPosUpdate` is `r.suppressInlPos`,
incremented in `reader.funcLit` around reading the closure's position and
signature. Change: removed the `suppressInlPos++ / --` pair in `funcLit`
(src/cmd/compile/internal/noder/reader.go), so the closure func's
position and signature positions are inline-adjusted again, as before the fix.

Oracle: all three cases fail. The compiler hits an internal compiler error
("oldBase ... already has inlining index", a cycle in the inlining tree)
while compiling runtime/proc.go, so closure3.go, inline.go and issue46234.go
all fail to build/run.
