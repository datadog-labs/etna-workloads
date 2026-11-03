# Rationale

Changed: `src/cmd/compile/internal/noder/writer.go`, in `(*writer).expr`.
I removed the block that emits `exprReshape` + `w.typ(typ)` for expressions of
derived type. This reverses the fix's `writer.go` hunk that added that block.
go1.27.3 still has the same block, in the same place, so removing it is
equivalent to the pre-fix writer. The reader's `exprReshape` case is left in
place. It is now never emitted, which matches pre-fix behaviour (the reader
had no such case before). The other hunks (debug flag, code constant, reader
case) only support the writer hunk, so I left them.

Oracle: `test/typeparam/issue54535.go` fails to compile with
`n.children[i].items undefined (type go.shape.*uint8 has no field or method items)`,
and likewise for `x.a.b` and `x.c.d`. These are the errors from the original
bug report.
